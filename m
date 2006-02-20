From: "Tuomas Leikola" <tuomas.leikola@gmail.com>
Subject: Re: Avoiding resync of RAID1 during creation
Date: Mon, 20 Feb 2006 22:27:40 +0200
Message-ID: <5b170a7d0602201227p5cb458a5j13aecca21aa3d627@mail.gmail.com>
References: <43F9E65D.6040402@datafoundry.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43F9E65D.6040402@datafoundry.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Bryan Wann <bryan@datafoundry.com>
Cc: linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 2/20/06, Bryan Wann <bryan@datafoundry.com> wrote:
> Now with FC4, raidtools is gone and I'm left with mdadm tools.  As far
> as I can tell, mdadm has nothing resembling --dangerous-no-resync.  I've
> updated my kickstart to use mdadm instead of mkraid using:
>

mdadm --assume-clean

from the man page:

It can also be used when creating a RAID1 or RAID10 if you want to
avoid the initial resync, however this  practice - while normally safe
- is not recommended.

/ tuomas
