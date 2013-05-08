From: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Subject: Re: New RAID
Date: Wed, 08 May 2013 07:33:30 -0700
Message-ID: <qa4q5ax2lq.ln2@goaway.wombat.san-francisco.ca.us>
References: <CACocew=6FLYc4xBq-H2XQH1QSKLq0GFFoRQxpjBkBAinFm7-4g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2013-05-08, Andras Fekete <iamfeketeandras@gmail.com> wrote:
>
> I'm trying to learn how the mdadm software works. I've been looking at the
> downloaded source for mdadm-3.2. My question is if I want to create a new
> kind of a RAID, how can I expand the code to do so? Is there some code
> overview/documentation page that I can look at? Perhaps a forum for asking
> questions about the source?

This is the right place to ask questions about linux md RAID, but mdadm
is probably not what you're looking for, as it's mostly the admin tool.
Most (all?) of the actual RAID implementation is in the linux kernel, so
if you wanted to add a completely new RAID type you'd want the kernel
source code.

The primary web documentation is here:

https://raid.wiki.kernel.org/

There are many links to other helpful resources.

--keith

-- 
kkeller@wombat.san-francisco.ca.us


