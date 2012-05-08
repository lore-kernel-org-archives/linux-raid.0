From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: logging the last state of the disk subsystem
Date: Tue, 8 May 2012 13:01:39 -0700
Message-ID: <CAA9_cmeO=juPtw01hHbgChsqV3GRYdyHrZ=Beecgqmpy0gGvCg@mail.gmail.com>
References: <CAMt+eY0VtyxmqGoJy1+-=0Ho_etfiyF8Rbr1Dz8+4zJA7KGSzg@mail.gmail.com>
	<CAMt+eY3faj3YszfEPMCbqHHespYK-582M5K6qFGssWpE9Mxxpw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAMt+eY3faj3YszfEPMCbqHHespYK-582M5K6qFGssWpE9Mxxpw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ivan Fedorets <ivan.fedorets@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, May 5, 2012 at 11:32 PM, Ivan Fedorets <ivan.fedorets@gmail.com=
> wrote:
> Hello Neil,
>
> There are some situations when metadata is changed or wiped out in th=
e
> attempts to recover a broken raid, or the order of partitions is lost=
=2E
>
> I'm thinking:
> =A0it might be handy to have an extra file
> /var/log/mdadm_last_assembled_state.log serving two purposes:
> 1. mdadm can use it in attempts to reassemble if array broke
> (non-hardware failure)
> 2. administrators in despair can post them here when they stuck with =
a
> broken raid: this way it will be easier to help them without asking t=
o
> provide more details
>
> The idea is to have txt or xml format file. We need a specific format
> to allow mdadm to use the information from the file for self-healing.
> The file should contain historical data: previous successful states,
> that's why I suggest to treat is as a log file. However, every chunk
> of data should be clearly separate, thus mdadm can use the latest one
> for self-healing.
>
> in case of successful assemble of raid(s), mdadm write something like=
:
>
> <start stage# XX date=3D .....>
> ..
> ..
> everything that needs to recover raid: disk order, chunk data,
> versions on metadata, type of the raid..
> using this command for example:
> ..
> output of the /proc/mdstat
> output of /proc/partitions
> output of fdisk -l
> output of df -h
> ..
> ..
> ..
>
> /etc/mdadm.conf is well known location, anaconda is writing into it,
> sometimes it's not populated correctly..
> So that new log file would serve as a secret stash in case of soft
> disaster when data is still there, but raid failed to assemble.
> Historical data written in chunks - stages with the number (Stage# XX=
)
> will allow someone to try to assemble defferent previous stages in
> case the last one somehow wrong..
> Also metadata can be backed up there and restored from there..
>
> I understand that it's easy to give an advise than to write code,
> however it can save some of your time as well :)

Ideally you wouldn't need to mess around with reconstructing the state
of the array from text files, it would help to just have binary images
of the metadata.  This is what I was aiming for with "dump/restore"
support [1], just never got around to addressing Neil's suggestions.

> PS I'm impressed with your level of support!

Yes, Neil sets a high bar for a subsystem maintainer.

--
Dan

[1]: http://marc.info/?l=3Dlinux-raid&m=3D131432488718108&w=3D2
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
