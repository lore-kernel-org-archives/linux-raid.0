From: Hendrik Visage <hvisage@envisage.co.za>
Subject: Re: XFS RAID only writing half the time
Date: Tue, 25 Nov 2003 20:57:53 +0200
Sender: linux-xfs-bounce@oss.sgi.com
Message-ID: <20031125185753.GM17908@hvs.envisage.co.za>
References: <114.2c0b3fa3.2cf4ee43@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-xfs-bounce@oss.sgi.com>
Content-Disposition: inline
In-Reply-To: <114.2c0b3fa3.2cf4ee43@aol.com>
Errors-to: linux-xfs-bounce@oss.sgi.com
To: AndyLiebman@aol.com
Cc: hvisage@envisage.co.za, linux-raid@vger.kernel.org, linux-xfs@oss.sgi.com
List-Id: linux-raid.ids

On Tue, Nov 25, 2003 at 12:41:23PM -0500, AndyLiebman@aol.com wrote:
> Hendrik, 
> 
> Thanks for that suggestion. I tried it. Went to Google and under "vm.bdflush" 
> found some documentation (http://www.faqs.org/docs/securing/chap6sec68.html) 
> that explained what the various numbers mean. I didn't understand them all, 
> but when I experimented and put in: 
> 
> 10  1200  0  0   500     3000    60      20      0  (Just changed the first 
> two figures) 

More Documentation is in /usr/src/linux/Documentation/filesystems/proc.txt,
look for "Table 2-2: Parameters in /proc/sys/vm/bdflush "

 I recall also fixing some values in the middle..

HEndrik
