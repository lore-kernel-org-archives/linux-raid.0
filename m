Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 665FEC47096
	for <linux-raid@archiver.kernel.org>; Thu,  3 Jun 2021 23:51:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E720613FE
	for <linux-raid@archiver.kernel.org>; Thu,  3 Jun 2021 23:51:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229825AbhFCXxM (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 3 Jun 2021 19:53:12 -0400
Received: from mga14.intel.com ([192.55.52.115]:15196 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229685AbhFCXxM (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 3 Jun 2021 19:53:12 -0400
IronPort-SDR: qoDjvwFBpCBeiakfUJEhbrC8xh18XaDhSjvXKtVWvnMo/pqobWLIEMppp0QQHtBQpzi6kP34uy
 y9An4HmSo69Q==
X-IronPort-AV: E=McAfee;i="6200,9189,10004"; a="203995091"
X-IronPort-AV: E=Sophos;i="5.83,246,1616482800"; 
   d="scan'208";a="203995091"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2021 16:51:26 -0700
IronPort-SDR: QPFEmQ2iBKP6CMSQgH8o1sq79K3qnCw8a/7avLc9/8VvdYhETxR3KlA1B6z7GLqGb4CO6LUDQg
 EAAu15xyp7OA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,246,1616482800"; 
   d="scan'208";a="636405926"
Received: from lkp-server02.sh.intel.com (HELO 1ec8406c5392) ([10.239.97.151])
  by fmsmga005.fm.intel.com with ESMTP; 03 Jun 2021 16:51:26 -0700
Received: from kbuild by 1ec8406c5392 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1lox7U-0006TC-SO; Thu, 03 Jun 2021 23:51:24 +0000
Date:   Fri, 04 Jun 2021 07:50:55 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [song-md:md-next] BUILD SUCCESS
 991e6befee6b08c6af7380eb6e451db57e7ed071
Message-ID: <60b96adf.EfkrcwBjCaCnr6tH%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree/branch: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
branch HEAD: 991e6befee6b08c6af7380eb6e451db57e7ed071  md: Constify attribute_group structs

elapsed time: 3976m

configs tested: 373
configs skipped: 3

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
arm                                 defconfig
arm64                            allyesconfig
arm64                               defconfig
arm                              allyesconfig
arm                              allmodconfig
arm                       omap2plus_defconfig
m68k                          amiga_defconfig
arm                           sunxi_defconfig
riscv                             allnoconfig
riscv                               defconfig
arm                         socfpga_defconfig
arm                            qcom_defconfig
sh                          sdk7786_defconfig
mips                       rbtx49xx_defconfig
parisc                           allyesconfig
mips                        vocore2_defconfig
mips                           ip27_defconfig
powerpc                      pasemi_defconfig
m68k                       m5249evb_defconfig
arm                         lpc32xx_defconfig
sh                           se7750_defconfig
nds32                               defconfig
parisc                generic-64bit_defconfig
powerpc                      ppc64e_defconfig
sh                        dreamcast_defconfig
arm                            zeus_defconfig
powerpc                       ebony_defconfig
arm                            xcep_defconfig
h8300                               defconfig
powerpc                 mpc834x_mds_defconfig
mips                        qi_lb60_defconfig
arm                      footbridge_defconfig
mips                  decstation_64_defconfig
mips                           ip22_defconfig
mips                      maltaaprp_defconfig
mips                     cu1830-neo_defconfig
powerpc                     pq2fads_defconfig
powerpc                      mgcoge_defconfig
arm                           spitz_defconfig
xtensa                              defconfig
powerpc                 mpc85xx_cds_defconfig
powerpc                    adder875_defconfig
m68k                         apollo_defconfig
powerpc               mpc834x_itxgp_defconfig
powerpc                      arches_defconfig
powerpc                           allnoconfig
h8300                     edosk2674_defconfig
sparc64                          alldefconfig
arm                     am200epdkit_defconfig
arm                        multi_v5_defconfig
arm                         cm_x300_defconfig
sh                          urquell_defconfig
mips                malta_qemu_32r6_defconfig
arm                       netwinder_defconfig
arm                        mvebu_v7_defconfig
powerpc                    gamecube_defconfig
powerpc                    mvme5100_defconfig
arm                      pxa255-idp_defconfig
arm                         s3c2410_defconfig
microblaze                          defconfig
arc                     nsimosci_hs_defconfig
arm                             mxs_defconfig
arm                           h5000_defconfig
ia64                      gensparse_defconfig
arm                          pxa168_defconfig
powerpc                 xes_mpc85xx_defconfig
sh                         apsh4a3a_defconfig
arc                         haps_hs_defconfig
arm                         mv78xx0_defconfig
sh                         ecovec24_defconfig
mips                        workpad_defconfig
arc                     haps_hs_smp_defconfig
arm                           sama5_defconfig
sh                            migor_defconfig
powerpc                     tqm8560_defconfig
powerpc                     tqm8541_defconfig
mips                            ar7_defconfig
m68k                             allmodconfig
powerpc                     taishan_defconfig
arm                        mini2440_defconfig
parisc                              defconfig
sh                               j2_defconfig
powerpc                 mpc837x_mds_defconfig
mips                       lemote2f_defconfig
arm                              alldefconfig
m68k                            q40_defconfig
m68k                          atari_defconfig
powerpc                   currituck_defconfig
arm                          collie_defconfig
arc                        vdk_hs38_defconfig
powerpc                     powernv_defconfig
arm                       cns3420vb_defconfig
mips                        jmr3927_defconfig
sh                           sh2007_defconfig
sh                        sh7763rdp_defconfig
sh                   secureedge5410_defconfig
arm                             ezx_defconfig
arm                          exynos_defconfig
sh                            hp6xx_defconfig
sh                          polaris_defconfig
sh                          landisk_defconfig
um                           x86_64_defconfig
powerpc                 mpc832x_mds_defconfig
mips                    maltaup_xpa_defconfig
mips                        bcm47xx_defconfig
s390                       zfcpdump_defconfig
arm                         bcm2835_defconfig
powerpc                  storcenter_defconfig
sh                          r7780mp_defconfig
arm                           h3600_defconfig
arm                            mps2_defconfig
arc                          axs103_defconfig
arm                         s3c6400_defconfig
sparc                       sparc32_defconfig
powerpc                     tqm8540_defconfig
sh                               alldefconfig
powerpc                     sbc8548_defconfig
mips                           rs90_defconfig
m68k                         amcore_defconfig
arm                        cerfcube_defconfig
powerpc                 canyonlands_defconfig
powerpc64                        alldefconfig
powerpc64                           defconfig
arc                           tb10x_defconfig
sh                           se7343_defconfig
sh                  sh7785lcr_32bit_defconfig
mips                   sb1250_swarm_defconfig
arm                    vt8500_v6_v7_defconfig
xtensa                generic_kc705_defconfig
mips                            gpr_defconfig
powerpc                     ep8248e_defconfig
mips                     loongson1c_defconfig
parisc                generic-32bit_defconfig
sh                          rsk7201_defconfig
sh                     magicpanelr2_defconfig
arm                        spear3xx_defconfig
h8300                       h8s-sim_defconfig
sh                         microdev_defconfig
powerpc                 mpc8315_rdb_defconfig
powerpc                     tqm5200_defconfig
sh                             shx3_defconfig
arm                           viper_defconfig
nios2                         3c120_defconfig
powerpc                      pcm030_defconfig
powerpc                   lite5200b_defconfig
arm                           u8500_defconfig
um                                  defconfig
nds32                             allnoconfig
openrisc                            defconfig
mips                           ip32_defconfig
sh                           se7619_defconfig
mips                        nlm_xlp_defconfig
arm                          imote2_defconfig
alpha                               defconfig
x86_64                            allnoconfig
arc                              alldefconfig
arm                        neponset_defconfig
sh                          lboxre2_defconfig
m68k                       m5475evb_defconfig
arm                          pcm027_defconfig
arm                         lubbock_defconfig
sh                        sh7785lcr_defconfig
mips                         rt305x_defconfig
arm                      tct_hammer_defconfig
arm                        mvebu_v5_defconfig
powerpc                 mpc8272_ads_defconfig
powerpc                        cell_defconfig
mips                        bcm63xx_defconfig
mips                        maltaup_defconfig
s390                             alldefconfig
powerpc                     tqm8548_defconfig
nios2                               defconfig
mips                         db1xxx_defconfig
powerpc                     pseries_defconfig
powerpc                      tqm8xx_defconfig
powerpc                      cm5200_defconfig
arm                  colibri_pxa270_defconfig
um                            kunit_defconfig
arm                       imx_v4_v5_defconfig
i386                             alldefconfig
m68k                                defconfig
arm                     davinci_all_defconfig
sh                      rts7751r2d1_defconfig
arc                            hsdk_defconfig
mips                       bmips_be_defconfig
powerpc                     mpc83xx_defconfig
xtensa                    xip_kc705_defconfig
mips                      maltasmvp_defconfig
openrisc                 simple_smp_defconfig
arc                        nsimosci_defconfig
powerpc                 mpc8560_ads_defconfig
arm                        vexpress_defconfig
mips                          rb532_defconfig
mips                           ci20_defconfig
arm                         axm55xx_defconfig
sh                             espt_defconfig
m68k                       m5208evb_defconfig
arm                            lart_defconfig
mips                  cavium_octeon_defconfig
arm                         lpc18xx_defconfig
arm                         palmz72_defconfig
sparc                               defconfig
powerpc                         wii_defconfig
arm                  colibri_pxa300_defconfig
m68k                          hp300_defconfig
powerpc                     redwood_defconfig
powerpc                         ps3_defconfig
sh                           se7206_defconfig
powerpc                 linkstation_defconfig
arm                         vf610m4_defconfig
riscv             nommu_k210_sdcard_defconfig
sh                     sh7710voipgw_defconfig
arm                         orion5x_defconfig
powerpc                 mpc836x_rdk_defconfig
mips                         tb0219_defconfig
m68k                        m5307c3_defconfig
arm                       multi_v4t_defconfig
arm                       spear13xx_defconfig
powerpc                    ge_imp3a_defconfig
openrisc                  or1klitex_defconfig
mips                      bmips_stb_defconfig
sh                            titan_defconfig
arc                          axs101_defconfig
powerpc                       maple_defconfig
sparc64                             defconfig
arm                           tegra_defconfig
powerpc                          allmodconfig
sh                              ul2_defconfig
mips                     loongson2k_defconfig
mips                      pistachio_defconfig
sh                        sh7757lcr_defconfig
arm                          moxart_defconfig
powerpc                 mpc8313_rdb_defconfig
mips                       capcella_defconfig
mips                  maltasmvp_eva_defconfig
arm                         nhk8815_defconfig
powerpc                 mpc837x_rdb_defconfig
arm                         shannon_defconfig
sh                         ap325rxa_defconfig
arm                          simpad_defconfig
mips                      malta_kvm_defconfig
arm                       versatile_defconfig
mips                          ath25_defconfig
arm                          gemini_defconfig
arm                           stm32_defconfig
arm                          badge4_defconfig
mips                         cobalt_defconfig
arm                       aspeed_g5_defconfig
arm                      jornada720_defconfig
sparc                       sparc64_defconfig
m68k                            mac_defconfig
m68k                        mvme147_defconfig
parisc                           alldefconfig
powerpc                      bamboo_defconfig
powerpc                       ppc64_defconfig
mips                          malta_defconfig
ia64                            zx1_defconfig
powerpc                      chrp32_defconfig
mips                        nlm_xlr_defconfig
xtensa                         virt_defconfig
powerpc                          g5_defconfig
i386                                defconfig
arm                         at91_dt_defconfig
arm                            mmp2_defconfig
arm                        magician_defconfig
powerpc                        icon_defconfig
ia64                             allmodconfig
ia64                                defconfig
ia64                             allyesconfig
m68k                             allyesconfig
arc                              allyesconfig
nios2                            allyesconfig
csky                                defconfig
alpha                            allyesconfig
xtensa                           allyesconfig
h8300                            allyesconfig
arc                                 defconfig
sh                               allmodconfig
s390                             allyesconfig
s390                             allmodconfig
s390                                defconfig
i386                             allyesconfig
sparc                            allyesconfig
mips                             allyesconfig
mips                             allmodconfig
powerpc                          allyesconfig
x86_64               randconfig-a002-20210602
x86_64               randconfig-a004-20210602
x86_64               randconfig-a003-20210602
x86_64               randconfig-a006-20210602
x86_64               randconfig-a005-20210602
x86_64               randconfig-a001-20210602
i386                 randconfig-a003-20210601
i386                 randconfig-a006-20210601
i386                 randconfig-a004-20210601
i386                 randconfig-a001-20210601
i386                 randconfig-a002-20210601
i386                 randconfig-a005-20210601
i386                 randconfig-a003-20210603
i386                 randconfig-a006-20210603
i386                 randconfig-a004-20210603
i386                 randconfig-a001-20210603
i386                 randconfig-a002-20210603
i386                 randconfig-a005-20210603
i386                 randconfig-a003-20210602
i386                 randconfig-a006-20210602
i386                 randconfig-a004-20210602
i386                 randconfig-a001-20210602
i386                 randconfig-a005-20210602
i386                 randconfig-a002-20210602
x86_64               randconfig-a015-20210601
x86_64               randconfig-a011-20210601
x86_64               randconfig-a012-20210601
x86_64               randconfig-a014-20210601
x86_64               randconfig-a016-20210601
x86_64               randconfig-a013-20210601
x86_64               randconfig-a015-20210603
x86_64               randconfig-a011-20210603
x86_64               randconfig-a012-20210603
x86_64               randconfig-a014-20210603
x86_64               randconfig-a016-20210603
x86_64               randconfig-a013-20210603
i386                 randconfig-a015-20210603
i386                 randconfig-a011-20210603
i386                 randconfig-a014-20210603
i386                 randconfig-a012-20210603
i386                 randconfig-a015-20210601
i386                 randconfig-a013-20210601
i386                 randconfig-a011-20210601
i386                 randconfig-a016-20210601
i386                 randconfig-a014-20210601
i386                 randconfig-a012-20210601
i386                 randconfig-a015-20210602
i386                 randconfig-a013-20210602
i386                 randconfig-a016-20210602
i386                 randconfig-a011-20210602
i386                 randconfig-a014-20210602
i386                 randconfig-a012-20210602
i386                 randconfig-a013-20210603
i386                 randconfig-a016-20210603
riscv                    nommu_k210_defconfig
riscv                            allyesconfig
riscv                    nommu_virt_defconfig
riscv                          rv32_defconfig
riscv                            allmodconfig
um                             i386_defconfig
x86_64                           allyesconfig
x86_64                    rhel-8.3-kselftests
x86_64                              defconfig
x86_64                               rhel-8.3
x86_64                      rhel-8.3-kbuiltin
x86_64                                  kexec

clang tested configs:
x86_64               randconfig-b001-20210601
x86_64               randconfig-b001-20210603
x86_64               randconfig-b001-20210602
x86_64               randconfig-a002-20210601
x86_64               randconfig-a004-20210601
x86_64               randconfig-a003-20210601
x86_64               randconfig-a006-20210601
x86_64               randconfig-a005-20210601
x86_64               randconfig-a001-20210601
x86_64               randconfig-a002-20210603
x86_64               randconfig-a004-20210603
x86_64               randconfig-a003-20210603
x86_64               randconfig-a006-20210603
x86_64               randconfig-a005-20210603
x86_64               randconfig-a001-20210603
x86_64               randconfig-a015-20210602
x86_64               randconfig-a011-20210602
x86_64               randconfig-a012-20210602
x86_64               randconfig-a014-20210602
x86_64               randconfig-a016-20210602
x86_64               randconfig-a013-20210602

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
