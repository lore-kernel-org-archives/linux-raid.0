From: Phil Turmel <philip@turmel.org>
Subject: Re: Mounting array at boot - works with some kernels but not others
Date: Sun, 03 Apr 2011 13:29:23 -0400
Message-ID: <4D98AE73.3040204@turmel.org>
References: <BANLkTinSwLgNze-EdRB6wu1o5QYApHbLXQ@mail.gmail.com>	<4D98AAD3.2050700@turmel.org> <BANLkTimogoGPhRCq-+aT=TobByyp4fdfAA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTimogoGPhRCq-+aT=TobByyp4fdfAA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dennis Grant <reccedg@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/03/2011 01:26 PM, Dennis Grant wrote:
> On Sun, Apr 3, 2011 at 1:13 PM, Phil Turmel <philip@turmel.org> wrote:
> 
>> On-list is fine.  A couple of clarifications below:
> 
>> Please do "mdadm --examine" on the component devices /dev/sda5 and /dev/sdb5.
> 
> As requested:
> 
> sudo mdadm --examine /dev/sda
> mdadm: No md superblock detected on /dev/sda.
> 
> sudo mdadm --examine /dev/sdb
> mdadm: No md superblock detected on /dev/sdb.

Retry:

mdadm --examine /dev/sda5
mdadm --examine /dev/sdb5

------------------------^

Phil
