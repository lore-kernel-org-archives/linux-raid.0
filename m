From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Help needed: array inactive after grow attempt
Date: Thu, 28 Apr 2016 23:12:39 +0100
Message-ID: <57228AD7.1050408@youngman.org.uk>
References: <1d5a8c36a6802a9e7e32eb056165f200@spoilbase.eu>
 <7cfbdd22b8c20acdb95fababfa1a04a6@spoilbase.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7cfbdd22b8c20acdb95fababfa1a04a6@spoilbase.eu>
Sender: linux-raid-owner@vger.kernel.org
To: Andread Mayrhoff <repro@spoilbase.eu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 28/04/16 20:50, Andread Mayrhoff wrote:
> I might add
> 
> ~/tmp # mdadm --stop /dev/md127
> mdadm: stopped /dev/md127
> ~/tmp # mdadm --assemble --scan
> mdadm: Failed to restore critical section for reshape, sorry.
>        Possibly you needed to specify the --backup-file
> 
> Thanks for helping me out of this...

Have you got the latest mdadm? See the "stuck reshape operation" thread
for details.

You could also try adding the --invalid-backup option to mdadm. It
shouldn't need a backup if you're adding more disk, though, so that
looks slightly odd to me.

Beyond those tips I'll not stray - my raid-fu is not the best and while
I'm confident of this information I don't believe in encouraging others
to take risks. If those don't work I'll let a better expert than me
chime in.

Cheers,
Wol
