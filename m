From: Weedy <weedy2887@gmail.com>
Subject: Re: Buffer I/O error... async page read
Date: Wed, 7 Feb 2018 01:27:40 -0500
Message-ID: <0a503f71-72ff-7744-f513-ecccccd30782@gmail.com>
References: <CAPE0SYxDgs6NY_ZALVY5kB5a-vrpK1GQvqqtf60gjCCmn2eP8g@mail.gmail.com>
 <CAPE0SYxdUMivzCv++RaHWt90QkMBBV-oCAiGjMUxVsWdezS0mg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPE0SYxdUMivzCv++RaHWt90QkMBBV-oCAiGjMUxVsWdezS0mg@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Liwei <xieliwei@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2018-02-06 08:55 AM, Liwei wrote:
> Just answering my question. Turns out the I/O errors are caused by the
> MD bad blocks log. There wasn't an easy way to clear the log unless I
> wrote over the supposedly bad blocks.
> 

All you needed to do was "--assemble --update=no-bbl".

Neil just posted to the list a couple days ago about this for someone else.
