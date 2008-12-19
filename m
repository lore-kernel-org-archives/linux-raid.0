From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: Roadmap for md/raid ???
Date: Fri, 19 Dec 2008 10:01:40 -0700
Message-ID: <e9c3a7c20812190901v2387d8d4s87100817c7832a8f@mail.gmail.com>
References: <32298247.1229677293053.JavaMail.ngmail@webmail11.arcor-online.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <32298247.1229677293053.JavaMail.ngmail@webmail11.arcor-online.net>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: piergiorgio.sartor@nexgo.de
Cc: neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Dec 19, 2008 at 2:01 AM,  <piergiorgio.sartor@nexgo.de> wrote:
> In case of HD failure and resync, the md will start
> the operations from the beginning to the end.
> On the other hand,  it would be wise to sync first the
> used blocks (20% in the example) and later the others,
> if necessary at all.
> Because the array will get faster to a "safe state".
>

One idea/question is whether we can take advantage of the trim/discard
commands added for SSD support to allow filesystems to tell MD which
parts of the array it cares about.  So for a lightly populated array
we can try to treat free space as a second class citizen.

--
Dan
