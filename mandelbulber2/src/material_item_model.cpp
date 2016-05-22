/*
 * material_item_model.cpp
 *
 *  Created on: 8 maj 2016
 *      Author: krzysztof
 */

#include "material_item_model.h"
#include "fractal_container.hpp"
#include "material.h"
#include "settings.hpp"
#include "initparameters.hpp"

cMaterialItemModel::cMaterialItemModel(QObject *parent) : QAbstractListModel(parent)
{
	container = NULL;
}

cMaterialItemModel::~cMaterialItemModel()
{
	// TODO Auto-generated destructor stub
}

void cMaterialItemModel::AssignContainer(cParameterContainer *_parameterContainer)
{
	if(_parameterContainer)
	{
		container = _parameterContainer;
	}
	else
	{
		qCritical() << "Parameter container is NULL";
	}
}

int cMaterialItemModel::rowCount(const QModelIndex &parent) const
{
	Q_UNUSED(parent);
	return materialIndexes.size();
}

QVariant cMaterialItemModel::data(const QModelIndex &index, int role) const
{
	Qt::ItemDataRole itemRole = (Qt::ItemDataRole)role;

	if(itemRole == Qt::DisplayRole)
	{
		int matIndex = materialIndexes.at(index.row());

		cParameterContainer params;
		cFractalContainer fractal;

		params.SetContainerName("material");
		InitMaterialParams(matIndex, &params);

		//copy parameters from main parameter container to temporary container for material
		for(int i=0; i < cMaterial::paramsList.size(); i++)
		{
			cOneParameter parameter = container->GetAsOneParameter(cMaterial::Name(cMaterial::paramsList.at(i), matIndex));
			params.SetFromOneParameter(cMaterial::Name(cMaterial::paramsList.at(i), matIndex), parameter);
		}

		cSettings tempSettings(cSettings::formatCondensedText);
		tempSettings.CreateText(&params, &fractal);
		return tempSettings.GetSettingsText();
	}

	if(itemRole == Qt::UserRole)
	{
		return materialIndexes.at(index.row());
	}

	return QVariant();
}

bool cMaterialItemModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
	Qt::ItemDataRole itemRole = (Qt::ItemDataRole)role;

	if(itemRole == Qt::EditRole)
	{
		//look for first free material index
		int matIndex = materialIndexes.at(index.row());

		cParameterContainer params;
		cFractalContainer fractal;
		params.SetContainerName("material");
		InitMaterialParams(matIndex, &params);

		cSettings tempSettings(cSettings::formatCondensedText);
		tempSettings.LoadFromString(value.toString());
		tempSettings.Decode(&params, &fractal);

		//copy parameters from temporary container for material to main parameter container
		for(int i=0; i < cMaterial::paramsList.size(); i++)
		{
			cOneParameter parameter = params.GetAsOneParameter(cMaterial::Name(cMaterial::paramsList.at(i), matIndex));
			container->SetFromOneParameter(cMaterial::Name(cMaterial::paramsList.at(i), matIndex), parameter);
		}
	}

	return true;
}

QVariant cMaterialItemModel::headerData(int section, Qt::Orientation orientation, int role) const
{
	// TODO Material name
	return "TODO Material name";
}

bool cMaterialItemModel::insertRows(int position, int rows, const QModelIndex &parent)
{
	Q_UNUSED(parent);

	beginInsertRows(QModelIndex(), position, position+rows-1);

	for(int r = 0; r < rows; r++)
	{
		//look for first free material indes
		int matIndex = FindFreeIndex();
		materialIndexes.insert(position + r, matIndex);
		InitMaterialParams(matIndex, container);
	}
	endInsertRows();
	return true;
}

int cMaterialItemModel::FindFreeIndex()
{
	bool occupied = false;
	int materialIndex = 1;
	do
	{
		occupied = false;
		for(int i = 0; i < materialIndexes.size(); i++)
		{
			if(materialIndex == materialIndexes[i])
			{
				occupied = true;
				materialIndex++;
				break;
			}
		}
	}
	while(occupied);

	return materialIndex;
}

void cMaterialItemModel::slotMaterialChanged(int matIndex)
{
	int row = 0;
	for(int i = 0; i <materialIndexes.size(); i++)
	{
		if(matIndex == materialIndexes[i])
		{
			row = i;
			break;
		}
	}
	emit dataChanged(index(row, 0, QModelIndex()), index(row, 0, QModelIndex()));
}