/*
 * Copyright (C) 2012,2013 Canonical, Ltd.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * Authors: Michael Terry <michael.terry@canonical.com>
 */

#ifndef UNITY_MOCK_POWERD_H
#define UNITY_MOCK_POWERD_H

#include <QtCore/QObject>

class Powerd: public QObject
{
    Q_OBJECT
    Q_FLAGS(DisplayFlags)

public:
    enum DisplayFlags {
        UseProximity          = 1, // Use proximity sensor to override screen state
        DisableAutoBrightness = 2, // Force autobrightness to be disabled
        Bright                = 4, // Request the screen to stay bright
    };

    explicit Powerd(QObject *parent = 0);

Q_SIGNALS:
    void displayPowerStateChange(int state, unsigned int flags);
};

#endif
