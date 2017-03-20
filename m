From: Youenn Gestin <youenn.gestin@grim-is-a-geek.fr>
Subject: Re: strange mirror write perf
Date: Mon, 20 Mar 2017 01:44:09 +0100
Message-ID: <91d1857a35f0c659387a409cc147ac92@grim-is-a-geek.fr>
References: <eda41097b3c3a385f83041f0df372912@grim-is-a-geek.fr>
 <6ec5f2dbefa2b7489d9f39d4833d5113@grim-is-a-geek.fr>
 <c0981a7c8b13facace1228ed0f99efdc@grim-is-a-geek.fr>
 <3a5e061d-696d-f331-87a5-411edc514ada@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3a5e061d-696d-f331-87a5-411edc514ada@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Le 2017-03-20 00:42, Adam Goryachev a écrit :
> On 20/03/17 02:14, Youenn Gestin wrote:
>> Hello,
>> 
>> I'm encountering a drop of write performance after creating a mirror 
>> with two whole disk ( sdc and sdd ) and i'm not able to find where it 
>> come from:
>> 
>> Perf before :
>> abyss ~ # dd bs=1M count=2024 if=/dev/zero of=/dev/sdd conv=fdatasync
>> 2024+0 records in
>> 2024+0 records out
>> 2122317824 bytes (2,1 GB, 2,0 GiB) copied, 14,1238 s, 150 MB/s
>> abyss ~ # dd bs=1M count=2024 if=/dev/zero of=/dev/sdc conv=fdatasync
>> 2024+0 records in
>> 2024+0 records out
>> 2122317824 bytes (2,1 GB, 2,0 GiB) copied, 14,7046 s, 144 MB/s
>> 
>> Creating the mirror :
>> abyss ~ # mdadm --create --verbose /dev/md/md6to --level=1
>> --raid-devices=2 /dev/sdc /dev/sdd
>> mdadm: Note: this array has metadata at the start and
>>     may not be suitable as a boot device.  If you plan to
>>     store '/boot' on this device please ensure that
>>     your boot-loader understands md/v1.x metadata, or use
>>     --metadata=0.90
>> mdadm: size set to 5860391488K
>> mdadm: automatically enabling write-intent bitmap on large array
>> Continue creating array? y
>> mdadm: Defaulting to version 1.2 metadata
>> mdadm: array /dev/md/md6to started.
>> 
>> Perf after :
>> abyss ~ # dd bs=1M count=2024 if=/dev/zero of=/dev/md/md6to 
>> conv=fdatasync
>> 2024+0 records in
>> 2024+0 records out
>> 2122317824 bytes (2,1 GB, 2,0 GiB) copied, 21,1528 s, 100 MB/s
> 
> Two possible thoughts:
> 1) Did you wait until the two drives had completed the initial sync
> before testing? "cat /proc/mdstat" will show this.
> 2) As noted, "mdadm: automatically enabling write-intent bitmap on
> large array" try to disable this to see if you get the results you
> were expecting.
> 
> Other than that, I'm not sure, but please reply, and if it isn't so
> simple, then someone else might jump in.
> 
> Regards,
> Adam

Hello,

You got it right on your 2nd tought !
Took a look at 
https://raid.wiki.kernel.org/index.php/Write-intent_bitmap , disabled it 
( mdadm --grow --bitmap=none /dev/md/md6to ) ang here we go :

abyss ~ # dd bs=1M count=2024 if=/dev/zero of=/dev/md/md6to 
conv=fdatasync
2024+0 records in
2024+0 records out
2122317824 bytes (2,1 GB, 2,0 GiB) copied, 14,5074 s, 146 MB/s

I'll check about this function to see if i'll need it or not tomorow,

Thank you !
