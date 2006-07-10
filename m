From: Henrik Holst <henrik.holst@idgmail.se>
Subject: Re: only 4 spares and no access to my data
Date: Mon, 10 Jul 2006 10:46:05 +0200
Message-ID: <44B213CD.5010907@idgmail.se>
References: <loom.20060709T205013-455@post.gmane.org> <62b0912f0607091223y3d0a1ab5xbc5fb01ce2a74f9e@mail.gmail.com> <loom.20060710T095111-275@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <loom.20060710T095111-275@post.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Karl Voit <neww@Karl-Voit.at>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Karl Voit wrote:
[snip]
> Well this is because of the false(?) superblocks of sda-sdd in comparison to
> sda1 to sdd1.

I don't understand this. Do you have more than a single partion on sda?
Is sda1 occupying the entire disk? since the superblock is the /last/
"128Kb" (I'm assuming 128*1024 bytes) the superblocks should be one and
the same.

Henrik Holst

