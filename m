From: Chris Murphy <lists@colorremedies.com>
Subject: Re: URE, link resets, user hostile defaults
Date: Fri, 1 Jul 2016 14:43:37 -0600
Message-ID: <CAJCQCtT2Sxi1GgmNaO8i46LuELpA_nrWLnVzAQMz7Qx_mdwXvw@mail.gmail.com>
References: <CAJCQCtT1qi1yLjE3Lor3ScVJx7aX4A_S_iM_=VhDtDCD_C9uqw@mail.gmail.com>
 <57721A47.8070203@suse.de> <CAJCQCtQ=DXWg6qK1+9bwQxrzpKUsRvaiaAnatYR-dupg7JOVzQ@mail.gmail.com>
 <20160629121751.GT15597@hungrycats.org> <CACsGCyRd388u4XXCSnoK4TpNoPibjhdgEJsHS=vR6aztDc=+2A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CACsGCyRd388u4XXCSnoK4TpNoPibjhdgEJsHS=vR6aztDc=+2A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Edward Kuns <eddie.kuns@gmail.com>
Cc: Zygo Blaxell <u0oo5pgu@umail.furryterror.org>, Chris Murphy <lists@colorremedies.com>, Hannes Reinecke <hare@suse.de>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Here's a fun one of these I just got off the Fedora users mailing list
with a laptop drive that's apparently hanging on *write*. This I would
not expect to take a long time for a drive to figure out, but... there
are more resets than there are write errors, and in fact there's no
discrete write error from the drive, all we know is the failed command
is a WRITE command.

What seems to happen is, everything in the queue gets obliterated in
the reset, and when ext4 finds out everything failed, not just one
write, it barfs and goes read only.

http://pastebin.com/3JAL297z

How might this turn out differently if the drive reported a single
discrete write error? I don't know how any file system tolerates this
because it's so rare. Would ext4 just try to write again? Would it try
to write to the same sector or another one? Or maybe the write finally
succeeds by resulting in a remap (?) But this sure is dang slow to
recover from a bad write. I don't understand the engineering rational
for this. Maybe it's a firmware bug?


Chris Murphy
