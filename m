From: Xiao Ni <xni@redhat.com>
Subject: The subarray is loaded container by load_container
Date: Thu, 7 Jul 2016 05:13:46 -0400 (EDT)
Message-ID: <1782686607.3885369.1467882826743.JavaMail.zimbra@redhat.com>
References: <1516157514.3880097.1467881964185.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1516157514.3880097.1467881964185.JavaMail.zimbra@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
Cc: Jes Sorensen <jes.sorensen@redhat.com>, tomasz.majchrzak@intel.com, aleksey.obitotskiy@intel.com, pawel.baldysiak@intel.com, artur.paszkiewicz@intel.com
List-Id: linux-raid.ids

Hi all

We encountered one problem at booting time:

Run MD devices:  mdadm: array /dev/md/OSVOLUME0 now has 2 devices (0 new) [FAILED]

mdadm -IRs returns 1 at the booting time. In fact the array is already running. The 
command mdadm -IRs shouldn't return 1 if all the arrays are running, right?

In IncrementalScan function, it scans all the raid in /run/mdadm/map. It contains the
subarray too. The return value is 1 from function load_container. So the return value
of IncrementalScan rv is set to 1. If all arrays are running already, I think mdadm -IRs
should return 0, not 1.

Should we checks earlier whether it's a container or not before calling load_container?

Best Regards
Xiao
