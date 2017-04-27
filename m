From: Ron Leach <ronleach@tesco.net>
Subject: Re: Recovery on new 2TB disk: finish=7248.4min (raid1)
Date: Thu, 27 Apr 2017 20:01:44 +0100
Message-ID: <59024018.8060006@tesco.net>
References: <590117CD.1000009@tesco.net> <5595439.7OflYnrvFF@matkor-lenovo>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5595439.7OflYnrvFF@matkor-lenovo>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 27/04/2017 15:58, Mateusz Korniak wrote:
>
> What is output of
>   iostat -x 30 2 -m
> during recovery ?
>

iostat command is not recognised - it perhaps is not installed; man 
iostat was not recognised either.

What would the command have done?  I may be able to post equivalent 
information - Smartctl is installed and enabled on sdb, the new disk.

Recovery is still going on - I have not wanted to disrupt it in case I 
mess it up.  (Though all the volatile user data is multiply backed up, 
none of the OS or configuration data is so I don't want to risk 
compromising the array contents.)

regards, Ron
