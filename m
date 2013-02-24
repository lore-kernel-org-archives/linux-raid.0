From: Phil Turmel <philip@turmel.org>
Subject: Re: Brocken Raid & LUKS
Date: Sun, 24 Feb 2013 15:25:20 -0500
Message-ID: <512A7730.7010600@turmel.org>
References: <5123A1CC.2000003@heisl.org> <51266360.9030402@turmel.org> <5126678D.9030101@heisl.org> <51266D73.5020700@turmel.org> <51267192.6090205@heisl.org> <51267467.9040603@turmel.org> <512675A6.1000801@heisl.org> <5126797C.8090105@heisl.org> <51269DE0.5070905@heisl.org> <512748FA.2000709@heisl.org> <51277876.30008@turmel.org> <51278793.80904@heisl.org> <512790AE.2080102@turmel.org> <5127B64A.3000808@heisl.org> <5127D857.9090204@heisl.org> <5127F2B8.4050601@turmel.org> <5127F45F.5020608@heisl.org> <512827FC.7010403@turmel.org> <5128336E.5060809@heisl.org> <51284762.2080202@turmel.org> <51289798.7050500@heisl.org> <5128E9F4.5040700@turmel.org> <5129421C.7070105@heisl.org> <51295599.5040907@turmel.org> <51295B1B.2030404@heisl.org> <51299135.1000206@turmel.org> <5129BCCC.7090202@heisl.org
 > <512A2094.3020008@turmel.org> <512A5A5A.5020904@heisl.org> <512A5CFA.6020205@turmel.org> <512A6897.3040809@heisl.org> <512A6F39.7090008@turmel.org> <512A74FA.8000100@heisl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <512A74FA.8000100@heisl.org>
Sender: linux-raid-owner@vger.kernel.org
To: Stone <stone@heisl.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 02/24/2013 03:15 PM, Stone wrote:
> Am 24.02.2013 20:51, schrieb Phil Turmel:
>> On 02/24/2013 02:23 PM, Stone wrote:
>>
>>> hm ok.
>>> what copy method recommend you?
>>> dd? (the duration is very long)
>> I normally use dc3dd.  For troublesome disks, gnu ddrescue is the better
>> choice.
> ok. this tool i do not know but i think this is the right way:
> ddrescue /dev/sdx /path/to/my/new/drive

If you have spares of the same size, simply duplicate to the spare:

ddrescue -b 4096 /dev/sdx /dev/sdy

