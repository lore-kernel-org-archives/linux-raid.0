From: Rickard Svensson <myhex2020@gmail.com>
Subject: Re: Debian Squeeze raid 1 0
Date: Thu, 16 Jan 2020 11:41:30 +0100
Message-ID: <CAC4UdkazYkOq=Bj4BzU=amnQZJvWcA6KtySr424BOWPABhnQGA@mail.gmail.com>
References: <CAC4UdkbjUVSpkBM88HB0UJMqXh+Pd7CRLaya=s81xMGs-9+m_Q@mail.gmail.com>
 <5E1D6C8E.8030607@youngman.org.uk> <CAC4UdkbwYvPHgufBPjNTWzcZW0FcGgGrbmFD_k_mc-Z7NVH9Pw@mail.gmail.com>
 <5E1E5798.60406@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5E1E5798.60406@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi, thanks again :)

The server is shut down, will copy the two broken disks.
I think (and hope) there has been a small amount of writing since the
problems occurred.

Unexpected problem with the names of ddrescue, but the apt-get package
in Debian called gddrescue, the program is called ddrescue.
I became uncertain because you mention that it works like dd, but it
doesn't use  if=foo of=bar  like regular dd?
Anyway the program  ddrescue --help  refers to the homepage
http://www.gnu.org/software/ddrescue/ddrescue.html  which I assume is
right one..?
And there are a lot of options, any tips on some special ones I should use?

I also wonder if it is right to let mdadm try to recover from all four
disks, the first one to stop working where three days before I
discovered it.
Isn't it better to just use three disks, the two disks that are ok,
and the last disk that got too many write errors the night before I
discovered everything?

Otherwise, you have confirmed/clarified that everything seems to work
the way I hoped.
And I will read up on all the news in mdadm, and dm-integrity sounds
interesting. Thanks!

Cheers Rickard
