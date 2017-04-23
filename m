From: =?UTF-8?Q?Patrik_Dahlstr=c3=b6m?= <risca@powerlamerz.org>
Subject: Re: Recover array after I panicked
Date: Sun, 23 Apr 2017 14:57:53 +0200
Message-ID: <cf11f724-57dc-cf44-d15a-4377796d2da7@powerlamerz.org>
References: <3957da08-6ff4-3c15-e499-157244a767aa@powerlamerz.org>
 <20170423101639.GA4471@metamorpher.de>
 <37269c2b-1788-a0b6-6d91-84c6b6bdd16c@powerlamerz.org>
 <645f80c8-9abe-e34e-91f0-950b9e852068@powerlamerz.org>
 <20170423124514.GA7049@metamorpher.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170423124514.GA7049@metamorpher.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 04/23/2017 02:45 PM, Andreas Klauer wrote:
> On Sun, Apr 23, 2017 at 02:32:07PM +0200, Patrik Dahlström wrote:
>> Any thoughts?
> 
> What's the exact size of your drives?
> 
> blockdev --getsize64 /dev/sd[abcdefg]
> 
$ blockdev --getsize64 /dev/sda /dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/sdf /dev/sdg
6001175126016
6201213935616
6001175126016
6001175126016
6001175126016
6001175126016
2000398934016

/dev/sdg is the OS disk running from USB cabinet.

I have a faint memory of not using the full drives when creating the
array. Maybe save ~%5 in case I get a replacement that is slightly
smaller than the drives I have today. I could probably check for zeros
at the end of a drive
