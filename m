From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: raid10 on centos 5
Date: Fri, 4 May 2007 13:23:41 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0705041323330.9571@p34.internal.lan>
References: <463B5DB3.6020502@istandfor.com>
 <CE7B1A4EF22E704CBFFD9A35BA5C82221E00D2@ausx3mpc110.aus.amer.dell.com>
 <463B6536.1010505@istandfor.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <463B6536.1010505@istandfor.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ruslan Sivak <rsivak@istandfor.com>
Cc: Patrick_Boyd@Dell.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

cat /proc/mdstat

is the raid10 personality installed?

On Fri, 4 May 2007, Ruslan Sivak wrote:

> Patrick_Boyd@Dell.com wrote:
>> No LVM over the two RAID 1's is more like RAID 1c which is just a
>> concatenation of RAID 1's. You don't get the striping that you get in
>> RAID 10.
>>
>> 
> That's what I guessed.  Can anyone let me know if it's possible to set up a 
> real md raid10?  Do I need to custom compile the kernel and do a kickstart 
> install or something?
>
> Russ
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
