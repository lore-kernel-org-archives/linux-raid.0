From: Ram Ramesh <rramesh2400@gmail.com>
Subject: Re: My MD is too big to resize ext4.
Date: Sat, 8 Jul 2017 13:37:58 -0500
Message-ID: <05c7f3c8-8eb1-a7c2-a3d3-125b00215aba@gmail.com>
References: <6c827d07-19d8-017b-ca95-5e6f84b7821a@gmail.com>
 <20170708161513.37b09dbc@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170708161513.37b09dbc@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.net>
Cc: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 07/08/2017 06:15 AM, Roman Mamedov wrote:
> On Fri, 7 Jul 2017 19:41:13 -0500
> Ram Ramesh <rramesh2400@gmail.com> wrote:
>
>> On the web, I only found one solution that required upgrading kernel to
>> some very recent one (not in my distro) and getting the bleeding edge
>> resize2fs. This makes me nervous. Is there a solution that avoids this.
> Considering the other possible options that have been mentioned, using the
> Ext4 built-in larger devices support (which has been implemented recently)
> seems to be your best bet.
> https://askubuntu.com/questions/779754/how-do-i-resize-an-ext4-partition-beyond-the-16tb-limit
>
> The required e2fsprogs version 1.43 is included in Ubuntu 16.10 by now, so you
> don't even need to build it from the source.
> https://packages.ubuntu.com/yakkety/e2fsprogs
>
> But really, if you have everything on one array with a single huge filesystem
> and no backups, that's just asking for trouble and a complete data loss.
>
Thanks. This is exactly the one that I was talking about as a web 
solution. Did not know it is available in 16.10.

Besides the above, I hear your last caution well. I do have backup by 
distributing files using rsync over multiple (old) disks (4+4+3+3TB). I 
just don't trust my back up and thus pretend that I do not have one. 
However, for a short one week trial, I think, I am ok.

Going forward, I will not be able to backup 24TB volume (if I succeed in 
building one big MD) as I will not have enough drives to distribute 
data. So, there is going to be a problem. So, I am thinking seriously 
building several smaller MD devices out of my 6x6TB drives. Look at my 
reply to Andreas. Let me know your thoughts on that. If I build smaller 
MDs each can be temporarily backed up for updates etc. So, I will still 
be ok with data as long as I work only on one MD at a time that fits my 
set of backup disks.

Ramesh


