From: Pim Zandbergen <P.Zandbergen@macroscoop.nl>
Subject: Re: freshly grown array shrinks after first reboot - major data loss
Date: Thu, 01 Sep 2011 19:44:53 +0200
Message-ID: <4E5FC495.7070909@macroscoop.nl>
References: <4E5FA4B5.6010407@macroscoop.nl> <4E5FAEF3.60501@macroscoop.nl> <4E5FB350.3040905@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E5FB350.3040905@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09/01/2011 06:31 PM, Doug Ledford wrote:
> Why is your raid metadata using this old version?  mdadm-3.2.2-6.fc15 
> will not create this version of raid array by default.  There is a 
> reason we have updated to a new superblock.

As you may have seen, the array was created in 2006, and has gone through
several similar grow procedures.

> Does this problem still occur if you use a newer superblock format 
> (one of the version 1.x versions)?

I suppose not. But that would destroy the "evidence" of a possible bug.
For me, it's too late, but finding it could help others to prevent this 
situation.
If there's anything I could do to help find it, now is the time.

If the people on this list know enough, I will proceed.

Thanks,
Pim

