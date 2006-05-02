From: David Mansfield <centos@dm.cobite.com>
Subject: RAID1: can't remove (or set-faulty) a disk during resync with mdadm
Date: Tue, 02 May 2006 15:36:45 -0400
Message-ID: <4457B4CD.7030709@dm.cobite.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I'm running on Centos 4.3 with the latest kernel so perhaps this is a 
'vendor uses old/modified kernel' problem, (kernel is 2.6.9-34.EL) but 
anyway here goes:

I have a degraded mirror.  The rebuild is proceeding with /dev/hda1 
'good' and /dev/hdb1 'syncing'.

I'd like to pull /dev/hdb1 out of the raid and go back to 'degraded' 
mode with no resync.

When I run mdadm --manage -f /dev/md1 /dev/hdb2 it only causes the 
resync to start again from the beginning, it doesn't actually mark it bad.

The same thing happens if there's a write error to /dev/hdb1 during 
resync, instead of failing, it simply restarts the resync.

I imagine the two are related - maybe 'set faulty' simply simulates an 
i/o error on the member, but during resync, the behavior is 'retry'.

Is there anything that can be done about this (other than politely ask 
vendor for a fix ;-)?

David
