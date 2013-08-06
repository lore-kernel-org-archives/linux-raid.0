From: Roberto Spadim <rspadim@gmail.com>
Subject: Re: when md raid1 superblock is bad block, what happens
Date: Tue, 6 Aug 2013 00:20:46 -0300
Message-ID: <CAH3kUhH9t4WneZ7ySeDvPfzLdsnx3+GBp8-t0qXdGVu3OsZLQQ@mail.gmail.com>
References: <CAAL-TMcqej1YYYoCJr3XV7GONYzUR4=8poMnzMcrzTjP7N84KQ@mail.gmail.com>
	<20130806114707.0c3ffc07@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130806114707.0c3ffc07@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Dong Wu <archer.wudong@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

another question, that i'm thinking now after this email...
i never read about, but... what's the size of super block?
could it be mirrored inside the disk like a raid1 inside the device
being used? if the first image of superblock is broken try to read the
next one
