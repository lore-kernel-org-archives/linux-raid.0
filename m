From: David Greaves <david@dgreaves.com>
Subject: Re: Spare disk could not sleep / standby
Date: Tue, 08 Mar 2005 08:51:58 +0000
Message-ID: <422D67AE.1000506@dgreaves.com>
References: <422D327D.11718.F8DB3@localhost>	<200503080414.j284EG510309@www.watkins-home.com>	<16941.11443.107607.735855@cse.unsw.edu.au>	<62b0912f0503072120776e0b56@mail.gmail.com> <16941.14813.465306.72004@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <16941.14813.465306.72004@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:

>As the event count needs to be updated every time the superblock is
>modified, the event count will be updated forever active->clean or
>clean->active transition.  All the drives in an array must have the
>same value for the event count, so the spares need to be updated even
>though they, themselves, aren't exactly 'active' or 'clean'.
>  
>
May I ask why?
I can understand why the active drives need to have the same superblock 
- it marks the data set as consistent and is used on restart to indicate 
integrity across the set and avoid a resync.
But the spare has no data on it. What does it mean that the superblock 
is up to date?
In fact isn't that misleading?
Surely, if anything, the spare _should_ have an out of date superblock?

David


