From: Michal Soltys <soltys@ziu.info>
Subject: Re: mdadm raid6->LVM->ext4 setup
Date: Wed, 17 Nov 2010 00:39:45 +0100
Message-ID: <4CE31641.50909@ziu.info>
References: <4CE2C8AC.7010103@geograph.co.za> <20101116221722.GC8943@maude.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101116221722.GC8943@maude.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: zoltans@geograph.co.za
List-Id: linux-raid.ids

On 10-11-16 23:17, Luca Berra wrote:
> On Tue, Nov 16, 2010 at 08:08:44PM +0200, Zoltan Szecsei wrote:
>>
>> *** Commands used:
>> mdadm --create /dev/md0 --metadata=1.2 --auto=md --assume-clean
>> --bitmap=internal --bitmap-chunk=131072 --chunk=512 --level=6
>> --raid-devices=8 /dev/sd[abcdefgh]
>> mdadm --detail --scan >> /etc/mdadm.conf
>> mdadm --assemble /dev/md0
> as i said this is not useful
>> pvcreate --metadatasize 512 /dev/md0
> you should use --dataalignment, not --metadatasize, also you should

Also with reference to metadatasize - keep in mind the value is rounded 
up to the /next/ 64k boundary (or it was a while ago, perhaps it's 
changed now). So in your case, 512 would really result with 576.

With reference to --dataalignment - there's also --dataalignoffset 
option (although not really important in your setup).

You might consider adjusting 
/sys/block/<yourmddevice>/md/stripe_cache_size to higher values when you 
have everything set. It tends to give quite a performance boost.
