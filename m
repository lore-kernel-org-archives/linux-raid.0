From: Gordon Henderson <gordon@drogon.net>
Subject: Re: Severe, huge data corruption with softraid
Date: Thu, 3 Mar 2005 09:00:10 +0000 (GMT)
Message-ID: <Pine.LNX.4.56.0503030854330.20284@lion.drogon.net>
References: <42264AF4.4000600@tls.msk.ru>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
In-Reply-To: <42264AF4.4000600@tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


When I was building a server recently, I ran into a file-system corruption
issue with ext3, although I didn't have the time to do anything about it
(or even verify that it wasn't me doing something stupid)

However, I only saw it when I used the  stride=8 parameter to mk2efs, and
the -j (ext3) option. Without those everything seemed fine.

The symptoms I saw were the filesystem having a size of -64Z after I'd
closed and deleted all files on it. An fsck of the filesystem owuld sfix
it (after correcting many errors) I didn't notice an actual file
corruption, but it seemed the filesystem was croaked.

I was able to verify that this happened without any RAID code (just a
plain old partition), so I'm not sure this has any bearing on the issues
in this thread, however..

Alas I've not had the time to go back and do some real tests. (and it's
not entirely possible its something to do with the old version of the
older e2fsutils in Debian woody)

Gordon
