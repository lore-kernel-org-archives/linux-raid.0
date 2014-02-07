From: Roberto Spadim <rspadim@gmail.com>
Subject: Re: Storage system
Date: Fri, 7 Feb 2014 13:45:45 -0200
Message-ID: <CAH3kUhFDe6=BvrAXGunwKj505Fgg-HZhfFxxv9jMRfJUqTNzQA@mail.gmail.com>
References: <20140206180909.GA2419@lazy.lzy>
	<52F49433.8080904@hesbynett.no>
	<CAJvUf-BTjmxonub0eWGNm1YNp4zYis5Mgti9FuRiQ8RbVY3cXQ@mail.gmail.com>
	<20140207211446.4cf96a7f@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140207211446.4cf96a7f@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.net>
Cc: Matt Garman <matthew.garman@gmail.com>, David Brown <david.brown@hesbynett.no>, Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

hum... IMHO...
security isn't cheap if you want performace, right?

with a disk with important data, I don't do rma
buy another and replace, it's cheap, less time lost, and more
performace without encryption, ok if you lost data, why you don't do
backup and mirror, maybe replication (databases)? replace the bad disk
and system works, restore backup and start jobs again

ok, but if you want crypt at disk? add a layer at filesystem is the
best option check:
1)HERL
if you have a crash at crypt, you lost raid and lvm, how to restore a
file if you can't start raid and lvm? you will restore the full disk
(terabytes) or you prefer restore some files (kb, mb, gb?)

2)HRLE
if you have a crash at crypt, you lost some files, but your lvm still
running and your raid system too

ok when you crash a disk you lost many things, but some things without
encryption are easier to read, data without crypt could be "HELLO
GUY", data with crypt coudl be "ASDFJWE", now, you remember that you
have a filename with "HELLO GUY", try to find it with a crash disk
with crypt, and without, without crypt is easier, right?

i think the best option is crypt at filesystem, and don't crypt
metadata (file name for example), just the data (file contents),
that's my opnion
