From: Roman Mamedov <rm@romanrm.net>
Subject: Re: Filesystem corruption on RAID1
Date: Fri, 14 Jul 2017 12:22:38 +0500
Message-ID: <20170714122238.77031d6e@natsu>
References: <c2fe6593-c806-ab9f-fcff-8327c013237b@assyoma.it>
 <20170713214856.4a5c8778@natsu>
 <592f19bf608e9a959f9445f7f25c5dad@assyoma.it>
 <d1255092-73f5-1ca4-0e68-69ff37631a26@thelounge.net>
 <cd37f90b86eb67be4c893b7fdf112692@assyoma.it>
 <CAJCQCtS=o27zF_sUEv0rTos_0x_7tNMdudBaDDOwxSvTz3zE5w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJCQCtS=o27zF_sUEv0rTos_0x_7tNMdudBaDDOwxSvTz3zE5w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, 13 Jul 2017 19:48:29 -0600
Chris Murphy <lists@colorremedies.com> wrote:

> Btrfs still tolerates many errors, read and write

Actually it was Btrfs which saved me back then. Btrfs was making two copies
of metadata blocks and restored corrupted copies from good ones, and also
signaled me that user files were also affected (via data checksums).

FS checksums do work, and if you have redundancy for the corrupted part (such
as metadata DUP by default, or data DUP (unusual) or data RAID1), allow the FS
to sustain through corruptions, including hardware-caused ones.

-- 
With respect,
Roman
