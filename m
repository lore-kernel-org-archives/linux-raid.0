From: Roberto Spadim <rspadim@gmail.com>
Subject: Re: sequential versus random I/O
Date: Wed, 29 Jan 2014 23:18:39 -0200
Message-ID: <CAH3kUhF_7y9ZkrFoh76XG5Q_YyTLpaLFOiSH=OY8Oda4MqAb6A@mail.gmail.com>
References: <CAJvUf-BbRMXvwwbVvstGPUV7xQpVBqVXLNvTHhYf_wv8=Ws9uw@mail.gmail.com>
	<CAH3kUhHM-dKXX3z2mo-512=ZL52AM_F547h58nsWRe7LogwbNA@mail.gmail.com>
	<CAH3kUhH1Kq2OO+G2nLCHDoDVsq331pisQSoicmmCvzdC0AS2ow@mail.gmail.com>
	<CAH3kUhFqWRQMybSfhymd5QTcPhGkDoou8vpmXrgwM+ZnfreWCg@mail.gmail.com>
	<CAH3kUhFis34dB6BYaWfAXeCc=ooBB2BcVN0rADP_FMzfV8T+bA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAH3kUhFis34dB6BYaWfAXeCc=ooBB2BcVN0rADP_FMzfV8T+bA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Matt Garman <matthew.garman@gmail.com>
Cc: Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

sorry again, the last interesting thing (that i remember)

compression is a nice feature, check this:
https://btrfs.wiki.kernel.org/index.php/Main_Page   (BTRFS may online
compress files, i don't know if it's stable)

http://en.wikipedia.org/wiki/JFS_(file_system)    (JFS version 1, but
i don't know if you will have bugs)

https://code.google.com/p/fusecompress/         (FUSE is a userland
filesystem tool, maybe not too fast as a kernel land filesystem, but
it do a nice job)
http://squashfs.sourceforge.net/                       (read-only filesystem)

end =]
