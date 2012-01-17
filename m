From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH 0/4] add --initrd argument to mdadm/mdmon
Date: Tue, 17 Jan 2012 21:16:16 +0100
Message-ID: <4F15D710.7080104@redhat.com>
References: <1326797330-4488-1-git-send-email-Jes.Sorensen@redhat.com> <4F15D29C.7070504@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F15D29C.7070504@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: neilb@suse.de, linux-raid@vger.kernel.org, kay@redhat.com, harald@redhat.com, lpoetter@redhat.com, mschmidt@redhat.com
List-Id: linux-raid.ids

On 01/17/12 20:57, Doug Ledford wrote:
> Patch set looks reasonable to me, although you missed adding the new
> option to the mdadm man page.
> 
> Do we have a specific systemd version for which we know that --initrd is
> needed, or a version before which it is the wrong thing to do?
> 
> Ditto for dracut, do we know what the minimum version of dracut is
> before it will use the --initrd parameter on its mdadm calls?

I actually did this on purpose - or rather I left it out of the help
message on purpose. The option is really only meant to be used by
dracut/systemd, it doesn't make much sense for normal users/admins to
play with it directly.

If you think it makes sense, I can add documentation for it.

Right now I believe dracut isn't ready to call mdadm with --initrd,
however systemd in rawhide is aware of the '@' hack. I am not sure of
the specific version, but we should document the final minimum versions
once it's all sorted so all distros know which versions to pick.

Cheers,
Jes
