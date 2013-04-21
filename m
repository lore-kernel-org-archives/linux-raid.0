From: Phil Turmel <philip@turmel.org>
Subject: Re: md RAID5: Disk wrongly marked "spare", need to force re-add it
Date: Sun, 21 Apr 2013 14:17:06 -0400
Message-ID: <51742D22.2080601@turmel.org>
References: <516869D2.9030506@bucksch.org> <516B3077.9020507@schinagl.nl> <516B590C.5060807@bucksch.org> <516AE7A0.4070504@schinagl.nl> <516BD5E0.4040007@bucksch.org> <516FF25B.4000907@bucksch.org> <516FFC13.2030803@ultratux.net> <5171CB91.1040708@bucksch.org> <5171EED3.8030505@bucksch.org> <5171F52D.4040701@bucksch.org> <51739405.1060805@fnarfbargle.com> <5173A159.70202@bucksch.org> <5173C353.6080008@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5173C353.6080008@fnarfbargle.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <lists2009@fnarfbargle.com>
Cc: Ben Bucksch <linux.news@bucksch.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Brad,

I'm sorry you've been sucked into exchanges with this troll.  (I spotted
the attitude in the original post.)  A couple comments below:

On 04/21/2013 06:45 AM, Brad Campbell wrote:

> Again : "Good news: In my desperation, I now ran the following dangerous
> command: mdadm --create /dev/md0 --assume-clean --level=raid5 -n 8
> --chunk=64 --layout=left-symmetric --metadata=0.90 /dev/sdj missing
> /dev/sdl /dev/sd[mopnq]"

I did find it interesting that Ben tried this on his own, given that's
the very advice he demanded not be given in his OP.

> How did you verify you had your disks in the correct order? Where did
> that command line come from?

Ben's shell skills seem to match his interpersonal communication skills
(weak).  The construct /dev/sd[mopnq] expands as if it was specified
/dev/sd[mnopq].  His misunderstanding of bracket syntax has wrecked his
array.  If he had used braces, or spelled out all the devices, he'd
probably be fine right now.

If he tries again, with this in mind, he might still be fine.  (I
haven't checked if his attempted device order was correct, though.)  If
I was inclined to respond directly to him, I'd further suggest he review
the list archives for "error recovery", "timeouts", and "scrubbing".  He
might learn enough to not suffer so much next time.

> This will be my last post on the subject. I pointed you at a path of
> action in my last post.

If Ben's attitude had moderated in following posts, I might have set
aside my first impression and cut him some slack.  That's a significant
consideration when non-native English is involved.  But it's clearly not
the case here.

My first *and* last post on this topic.

Phil
