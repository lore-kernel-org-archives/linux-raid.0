From: David Brown <david@westcontrol.com>
Subject: Re: potentially lost largeish raid5 array..
Date: Sat, 24 Sep 2011 17:16:40 +0200
Message-ID: <j5ksf5$oam$1@dough.gmane.org>
References: <201109221950.36910.tfjellstrom@shaw.ca> <201109231022.59437.tfjellstrom@shaw.ca> <4E7D152C.9080704@hardwarefreak.com> <201109231811.08061.tfjellstrom@shaw.ca> <4E7DCA66.4000705@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E7DCA66.4000705@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 24/09/2011 14:17, Stan Hoeppner wrote:
> On 9/23/2011 7:11 PM, Thomas Fjellstrom wrote:
>> On September 23, 2011, Stan Hoeppner wrote:
>
>>> When properly configured XFS will achieve near spindle throughput.
>>> Recent versions of mkfs.xfs read the mdraid configuration and configure
>>> the filesystem automatically for sw, swidth, number of allocation
>>> groups, etc. Thus you should get max performance out of the gate.
>>
>> What happens when you add a drive and reshape? Is it enough just to
>> tweak the
>> mount options?
>
> When you change the number of effective spindles with a reshape, and
> thus the stripe width and stripe size, you definitely should add the
> appropriate XFS mount options and values to reflect this. Performance
> will be less than optimal if you don't.
>
> If you use a linear concat under XFS you never have to worry about the
> above situation. It has many other advantages over a striped array and
> better performance for many workloads, especially multi user general
> file serving and maildir storage--workloads with lots of concurrent IO.
> If you 'need' maximum single stream performance for large files, a
> striped array is obviously better. Most applications however don't need
> large single stream performance.
>

If you use a linear concatenation of drives for XFS, is it not correct 
that you want one allocation group per drive (or per raid set, if you 
are concatenating a bunch of raid sets)?  If you then add another drive 
or raid set, can you grow XFS with another allocation group?

mvh.,

David


