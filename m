From: "Lelsie Rhorer" <lrhorer@satx.rr.com>
Subject: RE:
Date: Sun, 5 Apr 2009 00:05:17 -0500
Message-ID: <20090405050520.KWXV19140.cdptpa-omta03.mail.rr.com@Leslie>
References: <87f94c370904041738g4ef6221co6c3ace1ebf51dcdf@mail.gmail.com>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87f94c370904041738g4ef6221co6c3ace1ebf51dcdf@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Alternate theory - serious fsync performance issue
> 
> I don't know if it's related, but there is a lot of recent discussion
> related to fsync causing large delays in ext3.  Linus is saying his
> highspeed SDD is seeing multisecond delays.  He is very frustrated
> because the SDD should be more or less instantaneous.
> 
> The current thread is http://markmail.org/message/adiyz3lri6tlueaf
> 
> In one of the other threads I saw someone saying that in one test they
> had a fsync() call take minutes to return.  Apparently no one yet
> fully understands what is going on.  Seems like something that could
> in some way be related to what you are seeing.

Well, it could be.  I tried flushing the cashes numerous times while
testing, but I never could see it made a difference one way or the other.

