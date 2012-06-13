From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: Data Offset
Date: Wed, 13 Jun 2012 20:49:45 +0200
Message-ID: <20120613184945.GA7307@lazy.lzy>
References: <CAFhY2CjQAutSxzJ-7e+G-1Jw-U6JsFjBBHOmiqOxkhkZy6kd9g@mail.gmail.com>
 <20120605154427.192566af@notabene.brown>
 <CAFhY2CiDTMRSV2wFCMhT9ZstUkHkJS7E0p7SP-ssfqwaquo+0w@mail.gmail.com>
 <20120610074531.65eaed81@notabene.brown>
 <CAFhY2CgxkjH6JvJzvQt9XT0oawntK7YoTFqnXQJGzvqthD8XpQ@mail.gmail.com>
 <4FD86179.1080209@pierre-beck.de>
 <4FD88C50.1000104@turmel.org>
 <4FD8D439.10406@pierre-beck.de>
 <4FD8D7EE.5000805@turmel.org>
 <4FD8DA4A.8030800@pierre-beck.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4FD8DA4A.8030800@pierre-beck.de>
Sender: linux-raid-owner@vger.kernel.org
To: Pierre Beck <mail@pierre-beck.de>
Cc: Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

On Wed, Jun 13, 2012 at 08:22:02PM +0200, Pierre Beck wrote:
> I wonder if LVM activation can be done without writing to the array?
> IIRC it updates at least some timestamp ...

we tried setting the array itself read only,
which prevent (or it should) anybody above,
filesystem or LVM, to perform writes...

Neveretheless, the result was a bit "strange",
namely a kernel BUG() or similar, we had to
reset the PC.

I'm not sure if this was caused by other issue,
since the PC was in a not really healty state,
or a direct consequence of md device in r/o.

bye,

-- 

piergiorgio
