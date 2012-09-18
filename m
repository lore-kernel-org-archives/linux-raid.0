From: Phil Turmel <philip@turmel.org>
Subject: Re: MD device always starting as /dev/md127
Date: Tue, 18 Sep 2012 19:43:18 -0400
Message-ID: <50590716.40107@turmel.org>
References: <CAJ72viOHn_TxQ_gB7mp9Nu1ac+VBR96tCecOeOYJoXEfNvEw+g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJ72viOHn_TxQ_gB7mp9Nu1ac+VBR96tCecOeOYJoXEfNvEw+g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bryan Bush <bbushvt@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09/18/2012 07:19 PM, Bryan Bush wrote:
> I've moved the drives from one system to another and when the array
> starts up its always /dev/md127.

[snip /]

> If I do
> mdadm --stop /dev/md127
> then
> mdadm --assemble --scan
> It starts the array at /dev/md1
> 
> Any idea why it always starts as md127?

Update your initramfs on the new system.

HTH,

Phil

