From: Derek Vadala <derek@cynicism.com>
Subject: Re: raidtab -> mdadm conf file?
Date: Wed, 19 Feb 2003 15:53:55 -0500 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030219205355.542BD3B82A@jaded.cynicism.com>
References: <20030219202516.GC13439@rdlg.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20030219202516.GC13439@rdlg.net>
To: "Robert L. Harris" <Robert.L.Harris@rdlg.net>
Cc: Linux-Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, 19 Feb 2003, Robert L. Harris wrote:

>   I currently have about 30 machines using raidtools and /etc/raidtab.
> Does anyone have a script that will generate a complete mdadm conf
> file based on a raidtab or output from mdadm --detail?  While mdadm may

Assuming the arrays are operational you could do something like:


# echo "DEVICES /dev/sd*" > /etc/mdadm.conf
# mdadm --detail --scan >> /etc/mdadm.conf

Just adjust the first command so that it has the desired device set.

--
Derek Vadala, derek@cynicism.com, http://www.cynicism.com/~derek

