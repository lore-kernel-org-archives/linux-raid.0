From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: report on RAID tools bug/patch
Date: Fri, 6 Jun 2003 17:03:09 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16096.15533.937109.357788@notabene.cse.unsw.edu.au>
References: <3EE03841.1030306@shaolinmicro.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from David Chow on Friday June 6
To: David Chow <davidchow@shaolinmicro.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday June 6, davidchow@shaolinmicro.com wrote:
> Hi Neil,
> 
> Referring to the earlier patches you post to fix a problem in mkraid.c 
> which saids "array is active -- run raidstop first" . I've try it on 
> 1.003 from the redhat website and tested it on my system which seems 
> alright.  I think this problem has existed in almost all Linux 
> distribution as it has been hanging around for a long time. Would you 
> please fix it and it will make a lot of people happy :D Thanks.

I did "fix" it by writing mdadm :-)

I don't maintain raidtools so I'm afraid I cannot help you.

NeilBrown

> 
> --- mkraid.c 2002/11/05 19:34:57 1.1
> +++ mkraid.c 2002/11/05 19:35:29
> @@ -244,7 +244,7 @@ int main (int argc, char *argv[])
>      while (*args) {
>          for (p = cfg_head; p; p = p->next) {
>              if (strcmp(p->md_name, *args)) continue;
> - if (check_active(cfg))
> + if (check_active(p))
>                  goto abort;
>              if (force_flag) {
>                  fprintf(stderr, "DESTROYING the contents of %s in 5 
> seconds, Ctrl-C if unsure!\n", *args);
> 
> regards,
> David Chow
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
