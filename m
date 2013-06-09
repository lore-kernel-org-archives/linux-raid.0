From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: Is this expected RAID10 performance?
Date: Sun, 09 Jun 2013 08:09:44 -0400
Message-ID: <51B47088.4000501@redhat.com>
References: <CAO9HMNHVNQcU=FumFnLRd9b0msMr8fr0z6SmL82dksu+6CNXYA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAO9HMNHVNQcU=FumFnLRd9b0msMr8fr0z6SmL82dksu+6CNXYA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Steve Bergman <sbergman27@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 06/08/2013 03:56 PM, Steve Bergman wrote:
> Simply Googling "xfs zero" and sorting by date yields pages and pages
> of recent report hits.

This is a just silly. Try googling for "Santa Claus lives at the North Pole" or 
"Do pixies really exist". Both queries will give you rock solid evidence that 
you can share will us, down to a specific mail address for Santa :)

For that matter, try googling "ext4 zero length files".

In my experience, which is based on first hand experience and direct knowledge, 
what enterprise users and enterprise storage array vendors actually use when 
constructing Linux based storage devices, XFS is by far the more popular choice.

To be clear, you absolutely can lose data with *any* file system if you 
misconfigure your storage, ignore the barriers, etc. That definitely includes ext4.

The way ext4 and xfs both do things is a lot closer these days (mainly because 
the ext4 developers have continually harvested good ideas from XFS with XFS 
occasionally doing the same from ext4).

For any application, I always encourage users to try out a few file systems and 
see what is best for them.

It is a lot more interesting to share your actual setup and results. Much less 
interesting to echo uninformed, old claims.

Regards,

Ric



