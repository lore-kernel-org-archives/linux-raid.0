From: Mika Tiainen <mikat@iki.fi>
Subject: Re: Kernel doesn't find root from new style partitionable array
Date: Tue, 20 Jan 2009 14:09:17 +0200
Message-ID: <87zlhmxjpu.fsf@divinity.mikat.iki.fi>
References: <871vvbulaz.fsf@divinity.mikat.iki.fi>
 <496A8015.5000704@ziu.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <496A8015.5000704@ziu.info> (Michal Soltys's message of "Mon,
 12
	Jan 2009 00:26:13 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Michal Soltys <soltys@ziu.info>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


(Sorry for the late reply)

On 12 Jan 2009, Michal Soltys wrote:

> Mika Tiainen wrote:
>> Hi,
>>
>> When booting from another disk I can see that the md0 partitions are
>> only found later:
>>
>> md0: p1 p2
>>
>> This line shows up after root is already mounted.
>>
>
> I've never used in-kernel raid autodetection (always relying on
> initramfs - any reason not to use one ?),

Initrd is what I'm using now and it works, but I'd rather get by without
initrd as I have no other need for it.

> but looking at md.txt from kernel docs, raid=partitionable parameter
> should get it done. You might end with md_d0 (as in earlier kernels)
> name instead of md0, so adjust root=, fstab, etc. accordingly.

raid=partitionable is what I used before, but it doesn't work with these
new style partitions. The raid gets detected as md_d0, but no md_d0p1.

If this can't be fixed and these new partitionable arrays can't be used
as root without initrd it should be documented somewhere.

-- 
Mika Tiainen		Always be wary of any helpful item that
mikat@iki.fi		weighs less than its operating manual.
http://mikat.iki.fi	-- (Terry Pratchett, Jingo)
