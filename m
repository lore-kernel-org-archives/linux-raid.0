From: David Greaves <david@dgreaves.com>
Subject: Re: RAID issue (Fedora 9 issue?)
Date: Sun, 05 Oct 2008 10:49:38 +0100
Message-ID: <48E88DB2.9060503@dgreaves.com>
References: <48E81A7A.4080703@bubble.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <48E81A7A.4080703@bubble.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jeffrey Ross <jeff@bubble.org>
Cc: linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi

I use Debian so nothing Fedora specific, sorry.

For others, I note from the name of your initrd that you are running x86_64 and
2.6.26.5-45.fc9

Jeffrey Ross wrote:
> I tried the question on the Fedora mailing list and it was suggested I
> try here as well, hopefully somebody knows what I'm doing wrong, and its
> probably something simple.
> 
> The system has been running fine for months until now

> If boot the system recovery image, all the partitions are properly
> identified and started.
So the arrays seem to be OK. Good :)

> I have verified the contents of the
> /etc/mdadm.conf file that the UUID's are correct

Which mdadm.conf? The one on /dev/md6?
Youy need to check/update the one in the initrd.

Shouldn't have changed though unless you did a rebuild or something.

What superblock version are you using?
Is it possible the hostname changed? Later superblocks care about the homehost
(never used this feature so I don't know if you have to invoke it - just
throwing it out there).

> What has changed?  Not 100% sure, I have installed a handful of new
> patches recently since the last reboot and unfortunately I don't know
> which ones so there are a lot of possibilities.
OK
Kernel patches? Or rpms?

David

-- 
"Don't worry, you'll be fine; I saw it work in a cartoon once..."
