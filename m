From: Chris Murphy <lists@colorremedies.com>
Subject: Re: md raid behavior, bad sector uncorrectable read error
Date: Sun, 19 Aug 2012 20:06:45 -0600
Message-ID: <3D2BFD32-3039-4D65-9AAC-408D59F878D6@colorremedies.com>
References: <3E06D7FC-092A-4CB6-B79C-7EC94424DEEE@colorremedies.com> <CAGkViCFBqJJWeaA1Wrpc_BBw=wd1wV3nVrArEB51LJpJsrmsug@mail.gmail.com> <FEEB11B4-5CCB-49F4-8010-80CE03A49FA4@colorremedies.com> <20120820081935.24289755@notabene.brown>
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120820081935.24289755@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Aug 19, 2012, at 4:19 PM, NeilBrown wrote:

> On Sun, 19 Aug 2012 12:12:38 -0600 Chris Murphy <lists@colorremedies.com>
> wrote:
> 
>> On Aug 19, 2012, at 3:47 AM, Mikael Abrahamsson wrote:
>>> If I remember correctly from what has been described here before, a read error will cause a re-write with information created from parity
>> 
>> That's the thing I'd like to get a definitive answer one. If only it were easy to simulate bad sectors in VM's I could just test it!
> 
> If only it were easy to read the documentation, and if only the documentation
> were sufficiently complete.....
> 
> % man 4 md
> 
> search for 'read error'

The well deserved and diplomatic variant of RTFM. So the summary is: a write error on RAID 1456 causes md to mark the device as faulty. A read error (with recent kernels) causes correct data to overwrite the bad block *and* re-read, and if either write or re-read fails, the device is marked faulty. Very cool.

BTW, there's a lot of detail nuggets in man md that I'm not finding documented anywhere else. Nor have I found in other documentation a reference to man md until now.

Chris Murphy