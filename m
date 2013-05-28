From: Jon Nelson <jnelson-linux-raid@jamponi.net>
Subject: Re: mdadm vs zfs for home server?
Date: Tue, 28 May 2013 10:18:41 -0500
Message-ID: <CAKuK5J0rwP+POsLJaY_12xBfAChejHZvzPyLHmCAgyRgxVC8MQ@mail.gmail.com>
References: <20130527180912.GA6068@septictank.raw-sewage.fake>
 <5156525.31.1369681328163.JavaMail.root@zimbra> <20130528150050.GA1357@septictank.raw-sewage.fake>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130528150050.GA1357@septictank.raw-sewage.fake>
Sender: linux-raid-owner@vger.kernel.org
To: Matt Garman <matthew.garman@gmail.com>
Cc: Roy Sigurd Karlsbakk <roy@karlsbakk.net>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, May 28, 2013 at 10:00 AM, Matt Garman <matthew.garman@gmail.com> wrote:
> On Mon, May 27, 2013 at 09:02:08PM +0200, Roy Sigurd Karlsbakk wrote:
>> Short answer: ZFS will guarantee the data is free of errors, but
>> MD will give you the flexibility of moving between RAID levels and
>> adding drives to existing RAIDs. I have been working with ZFS with
>> some 400TB of storage, and I considered using it for my home
>> server, but chose MD because of the flexibility in there. ZFS
>> requires you to plan your setup. It allows you to add VDEVs, but
>> data isn't balanced over the VDEVs. That will required block
>> pointer rewrite, something that's been talked about for at least
>> four years, but yet hasn't surfaced.
>
>
> In the raid-10 case, does Linux MD automatically "reblance" the
> data?  I could be wrong, but my understanding is that it will let
> you grow the array, but in the same way that ZFS would (for raid10
> anyway): the extra space is there, but not striped across the
> original disks.

IIRC, as of March or so of last year (2012), kernels gained the
ability to grow MD RAID10 arrays *provided* they are not using the
"far" offset layout (sadly, my favorite).

--
Jon
