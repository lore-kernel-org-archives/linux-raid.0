From: Roman Mamedov <rm@romanrm.net>
Subject: Re: How to backup of large md raid volumes?
Date: Fri, 19 May 2017 10:01:42 +0500
Message-ID: <20170519100142.1f034b82@natsu>
References: <442a4af0-00d2-853d-5294-84ae0353262b@gmail.com>
        <75dc802b-1572-3c6f-ed62-4333deece4c2@websitemanagers.com.au>
        <8b840e53-1be2-b1b5-632f-e75f0c6c53b7@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8b840e53-1be2-b1b5-632f-e75f0c6c53b7@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ram Ramesh <rramesh2400@gmail.com>
Cc: Adam Goryachev <mailinglists@websitemanagers.com.au>, Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, 18 May 2017 22:39:59 -0500
Ram Ramesh <rramesh2400@gmail.com> wrote:

> Here is a summary of what I like to do. I want to backup files on to 
> (multiple) disks that will be loaded on to a USB dock. Simple one to one 
> copy is all I am looking for. I am not interested in full vs. 
> incremental or keeping versions of files for restore. My data is just 
> movies and songs. All I want is a SW that understands links (to avoid 
> duplicates) and copy files in batch on to multiple disks. I want content 
> of each (backup) disk to be independent. This way if one backup disk 
> dies, I have all other files unaffected by this failure. The only reason 
> I did not try multi-volume tar is the lack of independence across disks.

What I'm doing is storing files on my primary storage in folders according to
where they are backed up to.

E.g. "[back up of this is to be stored] On USB disk A", "B", etc.

In your case that would be:

/storage/OnDiskA/Movies/......
/storage/OnDiskA/Music/......

/storage/OnDiskB/Movies/......


-- 
With respect,
Roman
