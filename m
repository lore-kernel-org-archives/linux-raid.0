From: Alex <mysqlstudent@gmail.com>
Subject: Re: Possible data corruption after rebuild
Date: Fri, 6 Jul 2012 12:11:21 -0400
Message-ID: <CAB1R3sgwiM25ftpfZ3GkQNkGudwnk=R6Mu3orJJ3zYAc3g1C1w@mail.gmail.com>
References: <CAB1R3sjHtWwE7=MOqTzS7omiE-ebxqBPNaMMh-+_AYw3WgLtxg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAB1R3sjHtWwE7=MOqTzS7omiE-ebxqBPNaMMh-+_AYw3WgLtxg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

> /dev/md2 also has a problem, and I have no idea what to do there either.

I should add that when trying to run fsck on /dev/md2, I receive the following:

# fsck /dev/md2
fsck from util-linux 2.20.1
e2fsck 1.42.1 (17-Feb-2012)
Superblock has an invalid journal (inode 8).
Clear<y>?

I've aborted this in hopes there's some way to fix the filesystem properly.

Thanks,
Alex
