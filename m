From: Jacek Danecki <Jacek.Danecki@intel.com>
Subject: problem: mdadm: device /dev/sda not suitable for any style of array
Date: Fri, 20 Feb 2009 17:21:22 +0100
Message-ID: <499ED882.6040204@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

I've found today an issue during tests for creation of raid1 array on 
Fedora 11 rawhide (kernel 2.6.29-0.112.rc4.git3.fc11.i586). I've tested 
some versions between version labeled mdadm-3.0-devel2 (which was good) 
and the HEAD of branch devel-3.0 using git bisect tool. Logs are below.
After reboot problem disappeared for a moment, but during next tests it 
arrived again.

script test-create-problem1:

mdadm -CR /dev/md/imsm -e imsm  -n2 -z 102400 /dev/sda /dev/sdc
sleep 1
mdadm -CR /dev/md/raid1 -l 1  -n2 -z 102400 /dev/sda /dev/sdc
cat /proc/mdstat
sleep 1
mdadm -S /dev/md/raid1
mdadm -S /dev/md/imsm
mdadm --zero /dev/sda /dev/sdc
-------------------------------------------------------------
Test log:

# ./test-create-problem1
mdadm: device /dev/sda not suitable for any style of array
Personalities : [raid1]
md97 : inactive sdc[1](S) sda[0](S)
       418 blocks super external:imsm

unused devices: <none>
mdadm: stopped /dev/md/raid1
mdadm: stopped /dev/md/imsm

----------------------------------------
Log from bisect session:

# git bisect good
88c32bb1ec5d0c12eb557c4f46832fa4e1076784 is first bad commit
commit 88c32bb1ec5d0c12eb557c4f46832fa4e1076784
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Mon Dec 8 16:59:18 2008 -0700

     imsm: validate arrays being created against firmware capabilities

     These checks are only enabled when platform support for imsm is found,
     i.e. ahci driver is loaded and talking to an Intel(R) controller, and
     the option rom header is located.

     They can be turned off by setting the environment variable
     IMSM_NO_PLATFORM to 1.

     Signed-off-by: Dan Williams <dan.j.williams@intel.com>

:100644 100644 afbd7120e2c8a2f4d8adc90fdbff09c5dd37799a 
7f27aa46de199e877416de8c368624688958cb1d M      Makefile
:100644 100644 c1264825d930af4bd375971f5cfb33486db7be40 
bbdc9f9508b4c95e6322b6ac5e8f776e4c939780 M      platform-intel.h
:100644 100644 7066e8e607f46cd3ebc38b2f4a2624660fd86d41 
abc320632b0dcc065e2374fc7b0f04b6cd2a424d M      super-intel.c


--
Jacek
