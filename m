From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: Re: The subarray is loaded container by load_container
Date: Thu, 7 Jul 2016 12:16:11 +0200
Message-ID: <4f57d953-8545-4647-49e7-c434e1892fb6@intel.com>
References: <1782686607.3885369.1467882826743.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1782686607.3885369.1467882826743.JavaMail.zimbra@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Xiao Ni <xni@redhat.com>, linux-raid <linux-raid@vger.kernel.org>
Cc: Jes Sorensen <jes.sorensen@redhat.com>, tomasz.majchrzak@intel.com, aleksey.obitotskiy@intel.com, pawel.baldysiak@intel.com
List-Id: linux-raid.ids

On 07/07/2016 11:13 AM, Xiao Ni wrote:
> Hi all
> 
> We encountered one problem at booting time:
> 
> Run MD devices:  mdadm: array /dev/md/OSVOLUME0 now has 2 devices (0 new) [FAILED]
> 
> mdadm -IRs returns 1 at the booting time. In fact the array is already running. The 
> command mdadm -IRs shouldn't return 1 if all the arrays are running, right?
> 
> In IncrementalScan function, it scans all the raid in /run/mdadm/map. It contains the
> subarray too. The return value is 1 from function load_container. So the return value
> of IncrementalScan rv is set to 1. If all arrays are running already, I think mdadm -IRs
> should return 0, not 1.
> 
> Should we checks earlier whether it's a container or not before calling load_container?
> 
> Best Regards
> Xiao
> 

Hi Xiao,

I think you're right that mdadm -IRs should return 0 in this case.
IncrementalScan should not try loading a container from a member array,
because that will always fail. Can you check if this fixes the problem
for you?

diff --git a/Incremental.c b/Incremental.c
index ba97b00..cc01d41 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -1347,8 +1347,12 @@ restart:
 
                if (devnm && strcmp(devnm, me->devnm) != 0)
                        continue;
-               if (devnm && me->metadata[0] == '/') {
+               if (me->metadata[0] == '/') {
                        char *sl;
+
+                       if (!devnm)
+                               continue;
+
                        /* member array, need to work on container */
                        strncpy(container, me->metadata+1, 32);
                        container[31] = 0;

Thanks,
Artur

