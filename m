From: Mitchell Laks <mlaks@verizon.net>
Subject: modify mdadm-raid script
Date: Sun, 26 Jun 2005 20:10:50 -0400
Message-ID: <200506262010.50472.mlaks@verizon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Along the same lines as above:

Should I simply modify the init script
/etc/init.d/mdadm-raid

script to  add in 
--run to the line which starts the raid??

ie. change the line

               $MDADM -A -s 
to
               $MDADM -A -s --run

so that even if the array is degraded it will start??


Mitchell

Please tell me if I am really doing something really dangerous and dumb
...

Thanks!
Mitchell Laks
 

#!/bin/sh
#
# Start any arrays which are described in /etc/mdadm/mdadm.conf and which are
# not running already.
#
# Copyright (c) 2001-2004 Mario Jou/3en <joussen@debian.org>
# Distributable under the terms of the GNU GPL version 2.

MDADM=/sbin/mdadm
MDRUN=/sbin/mdrun
CONFIG=/etc/mdadm/mdadm.conf
DEBIANCONFIG=/etc/default/mdadm

test -x $MDADM || exit 0

AUTOSTART=true
test -f $DEBIANCONFIG && . $DEBIANCONFIG

case "$1" in
    start)
        if [ "x$AUTOSTART" = "xtrue" ] ; then
            if [ ! -f /proc/mdstat ] && [ -x /sbin/modprobe ] ; then
                /sbin/modprobe -k md > /dev/null 2>&1
            fi
            test -f /proc/mdstat || exit 0
            echo "Starting raid devices: "
            if [ -f $CONFIG ] && [ -x $MDADM ] ; then
                $MDADM -A -s
            elif [ -x $MDRUN ] ; then
                $MDRUN
            fi
            echo "done."
        fi
        ;;
    stop|restart|reload|force-reload)
        ;;
    *)
        echo "Usage: $0 {start|stop|restart|reload|force-reload}"
        exit 1
        ;;
esac

exit 0
