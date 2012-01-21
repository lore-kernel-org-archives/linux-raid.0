From: Lennart Poettering <lpoetter@redhat.com>
Subject: Re: [PATCH 0/4] add --initrd argument to mdadm/mdmon
Date: Sat, 21 Jan 2012 02:27:30 +0100
Message-ID: <4F1A1482.9070809@redhat.com>
References: <1326797330-4488-1-git-send-email-Jes.Sorensen@redhat.com> <4F15D29C.7070504@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F15D29C.7070504@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Jes.Sorensen@redhat.com, neilb@suse.de, linux-raid@vger.kernel.org, kay@redhat.com, harald@redhat.com, mschmidt@redhat.com, Lennart Poettering <lennart@poettering.net>
List-Id: linux-raid.ids

On 17.01.2012 20:57, Doug Ledford wrote:

>
> Patch set looks reasonable to me, although you missed adding the new
> option to the mdadm man page.

If you decide to document this it might make sense to add a reference to 
http://www.freedesktop.org/wiki/Software/systemd/RootStorageDaemons 
which explains the semantics in a bit more detail.

> Do we have a specific systemd version for which we know that --initrd is
> needed, or a version before which it is the wrong thing to do?

Well, systemd honours the '@' starting with v38, and for older versions 
the '@' is practically a NOP, but not break anything that wasn't broken 
anyway ;-)

Lennart
