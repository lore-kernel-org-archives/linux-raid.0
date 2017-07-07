From: Roman Mamedov <rm@romanrm.net>
Subject: Re: Linear device of two arrays
Date: Sat, 8 Jul 2017 02:53:18 +0500
Message-ID: <20170708025318.216210e7@natsu>
References: <CALee7hZYgLNO2siDJNtFge_BoocTXX-9BSgRHmMJH8MaH6V3LA@mail.gmail.com>
        <20170705214250.0ea99538@natsu>
        <595D2ADA.8010907@youngman.org.uk>
        <CALee7hZqmLK19tSEEFBgSWMKm9TRoUqLBCxUmbNJpwmM45BjTQ@mail.gmail.com>
        <20170707212036.GA26305@metamorpher.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170707212036.GA26305@metamorpher.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: Veljko <veljko3@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 7 Jul 2017 23:20:36 +0200
Andreas Klauer <Andreas.Klauer@metamorpher.de> wrote:

> Put LVM on top?
> 
> You could create LVM on the new array, copy your files over, then extend.
> 
> If you know LVM _really_ well, it's also possible to convert existing 
> filesystems without moving data (other than relocating the parts 
> occupied/unusable by LVM, i.e. one extent-size worth of data at 
> start and end of disk).

There is this tool which can convert filesystems/partitions to LVM in-place:

  https://github.com/g2p/blocks

however it requires a shrinkable filesystem, and XFS cannot be shrunk.

(Also it appears unmaintained with a number of long-standing unresolved
issues).

-- 
With respect,
Roman
