From: Phil Turmel <philip@turmel.org>
Subject: Re: metadata versions: 0.90 vs 1.2
Date: Wed, 13 Jun 2012 11:17:44 -0400
Message-ID: <4FD8AF18.70401@turmel.org>
References: <1339563343.41566.YahooMailClassic@web190003.mail.sg3.yahoo.com> <alpine.DEB.2.00.1206130744440.25054@uplift.swm.pp.se> <CAAYorBKkvGacKKDVqs+F3HP6q8DUANFB4HcM5mNqfgqm-qnh_A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAYorBKkvGacKKDVqs+F3HP6q8DUANFB4HcM5mNqfgqm-qnh_A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Emmanuel Noobadmin <centos.admin@gmail.com>
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, plug bert <plugbert@yahoo.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 06/13/2012 10:46 AM, Emmanuel Noobadmin wrote:
> On 6/13/12, Mikael Abrahamsson <swmike@swm.pp.se> wrote:
>> If you want to be able to mount the individual RAID1 members but still use
>> the newer version superblock, you need to use version 1.0 (stored at the
>> end of the device/partition).
>>
>> I'd recommend to go with 1.0 instead of 0.90.
> 
> Would metadata 1.0 boot with older grub? Since that's often why we're using 0.9.

It does.  It's what I use myself.

Phil
