From: Phil Turmel <philip@turmel.org>
Subject: Re: Brocken Raid & LUKS
Date: Sun, 24 Feb 2013 13:33:30 -0500
Message-ID: <512A5CFA.6020205@turmel.org>
References: <5123A1CC.2000003@heisl.org> <51265B0B.9020108@turmel.org> <51265DA7.2030209@heisl.org> <512660B9.8090609@turmel.org> <5126629A.1090002@heisl.org> <51266360.9030402@turmel.org> <5126678D.9030101@heisl.org> <51266D73.5020700@turmel.org> <51267192.6090205@heisl.org> <51267467.9040603@turmel.org> <512675A6.1000801@heisl.org> <5126797C.8090105@heisl.org> <51269DE0.5070905@heisl.org> <512748FA.2000709@heisl.org> <51277876.30008@turmel.org> <51278793.80904@heisl.org> <512790AE.2080102@turmel.org> <5127B64A.3000808@heisl.org> <5127D857.9090204@heisl.org> <5127F2B8.4050601@turmel.org> <5127F45F.5020608@heisl.org> <512827FC.7010403@turmel.org> <5128336E.5060809@heisl.org> <51284762.2080202@turmel.org> <51289798.7050500@heisl.org> <5128E9F4.5040700@turmel.org> <5129421C.7070105@heisl.org
 > <51295599.5040907@turmel.org> <51295B1B.2030404@heisl.org> <51299135.1000206@turmel.org> <5129BCCC.7090202@heisl.org> <512A2094.3020008@turmel.org> <512A5A5A.5020904@heisl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <512A5A5A.5020904@heisl.org>
Sender: linux-raid-owner@vger.kernel.org
To: Stone <stone@heisl.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 02/24/2013 01:22 PM, Stone wrote:
> Am 24.02.2013 15:15, schrieb Phil Turmel:
>> On 02/24/2013 02:10 AM, Stone wrote:
>>
>>> e2fsck: aborted
>>>
>>> the output have 711mb..
>>> do you ned more examples?
>>> what do you say to case1?
>> I think you need to see case2.  Case #1 isn't very good.

Case #2 ....
> same shit different partion.
> the logfile have 708mb
> :(


Hmm.  If one was clearly better than the other, I'd recommend you do
"fsck -y" with it.  But they are both ugly.  Not extraordinarily bad,
but bad.

I believe you should copy all three complete drives to spares, then try
"fsck -y" with case #1.  If it doesn't give you your data, put the
spares in your system and try case #2 with "fsck -y".

If neither case #1 nor case #2 give you (most of) your data, I'm out of
ideas. :-(

Phil
