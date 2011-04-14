From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 2/2] imsm: FIX: Be more patient during loading matadata
Date: Thu, 14 Apr 2011 01:36:00 -0700
Message-ID: <4DA6B1F0.5010207@intel.com>
References: <20110412125116.7062.36275.stgit@gklab-128-013.igk.intel.com>	<20110412125128.7062.38008.stgit@gklab-128-013.igk.intel.com>	<BANLkTinryn7FTdXMHx9HsMSQqpgykWW+Gg@mail.gmail.com>	<905EDD02F158D948B186911EB64DB3D192368340@irsmsx503.ger.corp.intel.com>	<BANLkTi=nontnQ_WKCaUWmosBDBihoDC7JA@mail.gmail.com> <20110414180846.6a71eeb9@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110414180846.6a71eeb9@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "Kwolek, Adam" <adam.kwolek@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids

On 4/14/2011 1:08 AM, NeilBrown wrote:
>> Why does this existing check:
>>
>>                 /* retry the load if we might have raced against mdmon */
>>                  if (err == 3&&  mdmon_running(devnum))
>>                          for (retry = 0; retry<  3; retry++) {
>>                                  usleep(3000);
>>                                  err = load_and_parse_mpb(dfd, s, NULL, 1);
>>                                  if (err != 3)
>>                                          break;
>>                          }
>
> It's pretty horrible that we need to do this, isn't it?

Yes.

> Maybe we need some way to synchronise with mdmon so we *know* if we have
> raced or not.
> i.e. mdmon keeps a count of the number of times it has updated the metadata.
> We send a message to get the count, read, then get the count again.
> The request blocks while mdmon is actually writing.
> If the counts are different, we read again.
> ??

Assuming we are only racing against dirty transitions maybe it is enough 
to poll md/array_state and if it signaled while reading the metadata we 
likely need to try again (of course with an intervening ping_monitor)?

--
Dan
