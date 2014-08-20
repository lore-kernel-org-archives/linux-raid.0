From: Chris Knipe <savage@savage.za.org>
Subject: Re: Correct RAID options
Date: Wed, 20 Aug 2014 16:45:18 +0200
Message-ID: <CA+4TWFsbgnSmim+RCMtkX-16sO+NZ=MLY+5hQ8nmF1PshQ1uWw@mail.gmail.com>
References: <027801cfbbdc$d33970f0$79ac52d0$@savage.za.org>
	<53F3EA59.6030808@hesbynett.no>
	<CA+4TWFtG0ofkzQH0-k-rjOakasQNvcNZDgit=KknE6TCaKXpgg@mail.gmail.com>
	<53F44F18.1020401@hesbynett.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <53F44F18.1020401@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi All,

Thanks for all the valued feedback and recommendations.  Chris
Schanzle has been a great help in tweaking what we already have and we
are seeing considerable improvements after making some changes as to
how (i|d)nodes are being cached and slab caches and what not.  There
still is fundamental issues based on other's recommendations that goes
back to how the servers was setup to begin with.

I'm slowly tweaking and getting everything stable again to a degree
where it actually works, and then we will more than likely deploy a
new front-end configured correctly (1M stripe sizes, xfs, proper mkfs
options, etc.) before starting some rolling process to move load and
reinstall each front-end server correctly.  We do need to
unfortunately take this drastic step as the raid arrays needs to be
trashed and re-created obviously.

Definitely learned a lot, and I'm sure that a lot of really useful
information has made it to the archives as well!

--
Chris.
