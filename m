From: "stone@heisl.org" <stone@heisl.org>
Subject: Re: Brocken Raid & LUKS
Date: Mon, 25 Feb 2013 10:06:10 +0100
Message-ID: <512B2982.4090304@heisl.org>
References: <5123A1CC.2000003@heisl.org> <51267467.9040603@turmel.org> <512675A6.1000801@heisl.org> <5126797C.8090105@heisl.org> <51269DE0.5070905@heisl.org> <512748FA.2000709@heisl.org> <51277876.30008@turmel.org> <51278793.80904@heisl.org> <512790AE.2080102@turmel.org> <5127B64A.3000808@heisl.org> <5127D857.9090204@heisl.org> <5127F2B8.4050601@turmel.org> <5127F45F.5020608@heisl.org> <512827FC.7010403@turmel.org> <5128336E.5060809@heisl.org> <51284762.2080202@turmel.org> <51289798.7050500@heisl.org> <5128E9F4.5040700@turmel.org> <5129421C.7070105@heisl.org> <51295599.5040907@turmel.org> <51295B1B.2030404@heisl.org> <51299135.1000206@turmel.org> <5129BCCC.7090202@heisl.org> <512A2094.3020008@turmel.org> <512A5A5A.5020904@heisl.org> <512A5CFA.6020205@turmel.org> <512A6897.3040809@heisl.org
 > <512A6F39.7090008@turmel.org> <512A74FA.8000100@heisl.org> <512A7730.7010600@turmel.org> <512A7A2D.3040109@heisl.org> <512A7BC6.5010406@turmel.org> <512A7C66.6020701@heisl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <512A7C66.6020701@heisl.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Am 24.02.2013 21:47, schrieb Stone:
> Am 24.02.2013 21:44, schrieb Phil Turmel:
>> On 02/24/2013 03:38 PM, Stone wrote:
>>> if i can copy data. is there a way to check the files of consistency?
>>> thx
>> I'm not sure which files' consistency you mean here...  the dd image in
>> your nas?  If so, you compute md5sums of each entire disk (rather time
>> consuming).
>>
>> If you mean the data inside your encrypted array...  You can only use
>> whatever consistency mechanisms you already have for those files, like
>> "par2" Reed-Solomon checksums.
>>
>> Phil
> Yes i mean the data inside my encrypted array. i cannot check every 
> file per hand ;-)

on the sde disk i get some errors:
here some examples.
    ipos:     1999 GB,   errors:       0,    average rate:   95478 kB/s
    opos:     1999 GB,     time from last successful read:       0 s
Copying non-trrescued:     1999 GB,  errsize:       0 B,  current 
rate:   56885 kB/s
    ipos:     1999 GB,   errors:       0,    average rate:   95476 kB/s
    opos:     1999 GB,     time from last successful read:       0 s
Copying non-trrescued:     1999 GB,  errsize:       0 B,  current 
rate:   58851 kB/s
    ipos:     1999 GB,   errors:       0,    average rate:   95474 kB/s
    opos:     1999 GB,     time from last successful read:       0 s
Copying non-trrescued:     1999 GB,  errsize:       0 B,  current 
rate:   57802 kB/s
    ipos:     1999 GB,   errors:       0,    average rate:   95472 kB/s
    opos:     1999 GB,     time from last successful read:       0 s
Copying non-trrescued:     1999 GB,  errsize:       0 B,  current 
rate:   53870 kB/s
    ipos:     1999 GB,   errors:       0,    average rate:   95470 kB/s
    opos:     1999 GB,     time from last successful read:       0 s
Copying non-trrescued:     1999 GB,  errsize:       0 B,  current 
rate:   57540 kB/s
    ipos:     1999 GB,   errors:       0,    average rate:   95468 kB/s
    opos:     1999 GB,     time from last successful read:       0 s

