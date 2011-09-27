From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: potentially lost largeish raid5 array..
Date: Mon, 26 Sep 2011 22:53:35 -0500
Message-ID: <4E8148BF.5090406@hardwarefreak.com>
References: <201109221950.36910.tfjellstrom@shaw.ca>  <201109231022.59437.tfjellstrom@shaw.ca>  <4E7D152C.9080704@hardwarefreak.com>  <201109231811.08061.tfjellstrom@shaw.ca>  <4E7DCA66.4000705@hardwarefreak.com> <j5ksf5$oam$1@dough.gmane.org>  <4E7E079C.4020802@hardwarefreak.com> <j5n921$9oj$1@dough.gmane.org>  <4E7F3D24.5050300@hardwarefreak.com> <j5ngnt$ms1$1@dough.gmane.org>  <4E7FC042.7040109@hardwarefreak.com> <j5plld$fa1$1@dough.gmane.org>  <4E80D815.9080005@hardwarefreak.com> <1317079695.27455.1.camel@oxygen.netxsys.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1317079695.27455.1.camel@oxygen.netxsys.com>
Sender: linux-raid-owner@vger.kernel.org
To: Krzysztof Adamski <k@adamski.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 9/26/2011 6:28 PM, Krzysztof Adamski wrote:
> On Mon, 2011-09-26 at 14:52 -0500, Stan Hoeppner wrote:
>> Coincidentally, recent versions of mkfs.xfs will read the mdadm
>> config
>> and build the filesystem correctly, automatically, on top of striped
>> md
>> raid arrays.
>
> If I have LVM on top of RAID6, will mkfs.xfs read the mdadm config?

I believe the correct answer is that it should, but it depends on a few 
things.  Support for this may be new enough that some/many distros won't 
do it out of the box.  You may need to build some code yourself, linked 
with the proper libraries.  See the following list thread for 
background, which is a year old, so you may want to ask this question 
directly on the XFS list, or see the XFS FAQ:

http://oss.sgi.com/archives/xfs/2010-09/msg00161.html
http://xfs.org/index.php/XFS_FAQ

-- 
Stan
