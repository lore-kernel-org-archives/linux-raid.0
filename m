From: Derek Piper <derek.piper@gmail.com>
Subject: Re: Is there any way to delay reconstruction
Date: Wed, 25 May 2005 10:25:11 -0500
Message-ID: <eaa6dfe0505250825295cb284@mail.gmail.com>
References: <Pine.LNX.4.61.0505250811520.16854@desktop.agenda.si>
Reply-To: Derek Piper <derek.piper@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0505250811520.16854@desktop.agenda.si>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Why would rebooting the machines cause raid reconstruction? that
sounds pretty bad to need to do that. Shouldn't that be addressed
first? Then you might not need to worry about reconstruction so much.

Derek

On 5/25/05, danci@agenda.si <danci@agenda.si> wrote:

> The problem is that usually fails with 'hdX: lost interrupt' if the disks
> are busy due to RAID reconstruction - which happens a lot as some of the
> 800+ machines get rebooted for various reasons...
> 


-- 
Derek Piper - derek.piper@gmail.com
http://doofer.org/
