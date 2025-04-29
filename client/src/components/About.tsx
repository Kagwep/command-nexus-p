import React from 'react';
import { Shield, Users, Target, Map, Award, BookOpen, Video, Play, FileText, DollarSign, Terminal, Zap } from 'lucide-react';

const About = () => {
  const tactics = [
    {
      name: 'Flanking Maneuver',
      description: 'Approach enemy units from multiple angles to divide their attention and firepower.'
    },
    {
      name: 'Strategic Retreat',
      description: 'Withdraw damaged units to preserve force strength and reorganize defensive positions.'
    },
    {
      name: 'Pincer Movement',
      description: 'Encircle enemy formations with coordinated attacks from multiple directions.'
    },
    {
      name: 'Cover System',
      description: 'Utilize terrain features to maximize unit protection while maintaining offensive capability.'
    }
  ];

  const combatOps = [
    {
      name: 'Recon Intelligence',
      description: 'Send units to gather battlefield intelligence about enemy positions and strength.'
    },
    {
      name: 'Supply Line Disruption',
      description: 'Target enemy logistics to reduce their resource regeneration capabilities.'
    },
    {
      name: 'Defensive Perimeter',
      description: 'Establish a fortified zone with overlapping fields of fire for maximum protection.'
    },
    {
      name: 'Electronic Warfare',
      description: 'Deploy cyber units to disrupt enemy communications and tactical capabilities.'
    }
  ];

  const unitTypes = [
    {
      title: 'Infantry',
      desc: 'Versatile ground forces with high adaptability',
      icon: Users
    },
    {
      title: 'Armored',
      desc: 'Heavy combat units with superior firepower',
      icon: Shield
    },
    {
      title: 'Air',
      desc: 'Aerial units providing tactical mobility and strikes',
      icon: Target
    },
    {
      title: 'Naval',
      desc: 'Maritime forces controlling water territories',
      icon: Map
    },
    {
      title: 'Cyber',
      desc: 'Electronic warfare specialists',
      icon: Terminal
    }
  ];

  const battlefieldInfo = [
    {
      terrain: 'Urban Environment',
      features: [
        'Multi-level engagement zones',
        'Cover system (0-100 rating)',
        'Building and street warfare'
      ]
    },
    {
      terrain: 'Combat Conditions',
      features: [
        'Dynamic weather effects',
        'Visibility impacts',
        'Terrain advantages'
      ]
    }
  ];

  // Tutorials array
  const tutorials = [
    {
      title: 'Basic Controls',
      description: 'Learn how to navigate the battlefield and control your units effectively',
      type: 'Video',
      url: 'https://www.youtube.com/embed/basic_controls',
      icon: Play,
      color: 'text-green-400'
    },
    {
      title: 'Wallet Connection',
      description: 'Step-by-step guide to connect your digital wallet with the Cartridge Controller',
      type: 'Video',
      url: 'https://www.youtube.com/embed/wallet_connection_tutorial',
      icon: DollarSign,
      color: 'text-yellow-400'
    },
    {
      title: 'NFT Unit Deployment',
      description: 'Deploy your NFT units and utilize their special abilities in combat',
      type: 'Video',
      url: 'https://www.youtube.com/embed/nft_unit_deployment',
      icon: Target,
      color: 'text-blue-400'
    },
    {
      title: 'Marketplace Guide',
      description: 'Learn how to trade units and access the in-game marketplace',
      type: 'Document',
      url: '/guides/marketplace.pdf',
      icon: FileText,
      color: 'text-purple-400'
    },
    {
      title: 'Advanced Tactics',
      description: 'Master the combat system with these strategic techniques',
      type: 'Interactive',
      url: '/interactive/tactics',
      icon: BookOpen,
      color: 'text-red-400'
    },
    {
      title: 'Complete Field Manual',
      description: 'Comprehensive documentation of all game mechanics and systems',
      type: 'Document',
      url: '/guides/field_manual.pdf',
      icon: FileText,
      color: 'text-cyan-400'
    }
  ];

  // Handle tutorial click instead of using Link
  const handleTutorialClick = (url) => {
    // You can implement navigation logic here
    // For example, opening in a new tab, showing a modal, etc.
    window.open(url, '_blank');
    // Or you could use window.location.href = url; for same-window navigation
  };

  return (
    <div className="min-h-screen bg-gray-900 pt-16 relative">
      {/* Background Overlay */}
      <div className="absolute inset-0 bg-[url('/images/battlefield-map.jpg')] bg-cover bg-center opacity-10"></div>
      <div className="absolute inset-0 bg-gradient-to-b from-black/80 via-gray-900/90 to-gray-900"></div>
      
      {/* Header with animated text */}
      <header className="relative z-10 max-w-6xl mx-auto px-4 pt-8 text-center">
        <h1 className="text-4xl md:text-5xl font-bold text-green-400 font-mono mb-2">BATTLEFIELD COMMAND</h1>
        <p className="text-green-300/70 text-lg">Tactical Combat Interface - Version 2.4.1</p>
        <div className="h-1 w-32 bg-green-500/50 mx-auto mt-6 mb-12"></div>
      </header>
      
      <div className="max-w-6xl mx-auto px-4 py-8 relative z-10">
        <div className="relative bg-black/40 rounded-lg border border-green-500/20 overflow-hidden">
          {/* Terminal Header */}
          <div className="bg-black/60 border-b border-green-500/30 px-4 py-2 flex items-center">
            <div className="flex space-x-2 mr-4">
              <div className="w-3 h-3 rounded-full bg-red-500"></div>
              <div className="w-3 h-3 rounded-full bg-yellow-500"></div>
              <div className="w-3 h-3 rounded-full bg-green-500"></div>
            </div>
            <div className="text-green-400 font-mono text-sm">commander@tactical-interface: ~/mission-briefing</div>
          </div>
          
          <div className="p-8 space-y-8">
            {/* Mission Briefing */}
            <section className="mb-10">
              <div className="flex items-center mb-4">
                <Zap className="text-green-400 mr-2" size={24} />
                <h2 className="text-3xl font-mono text-green-400">Mission Briefing</h2>
              </div>
              <p className="text-green-100/80 mb-4 border-l-2 border-green-500/50 pl-4">
                Welcome to the Battlefield Command tactical interface. This system provides critical operational
                information and combat training for all field commanders. Familiarize yourself with all sections
                to maximize combat effectiveness and mission success probability.
              </p>
              <div className="text-yellow-400/70 inline-block border border-yellow-500/30 px-3 py-1 rounded bg-yellow-900/20 text-sm">
                CLASSIFIED INFORMATION // AUTHORIZED PERSONNEL ONLY
              </div>
            </section>

            {/* Tutorials Section */}
            <section className="bg-black/30 border border-green-500/20 p-6 rounded-lg">
              <h2 className="text-2xl font-mono text-green-400 mb-4 pb-2 border-b border-green-500/30">
                FIELD TUTORIALS
              </h2>
              <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                {tutorials.map((tutorial, index) => (
                  <div 
                    key={index} 
                    className="p-4 bg-green-900/10 border border-green-500/20 rounded hover:bg-green-900/20 transition-colors group cursor-pointer"
                    onClick={() => handleTutorialClick(tutorial.url)}
                  >
                    <div className="flex items-start space-x-3">
                      <div className={`rounded-full p-2 ${tutorial.color}/20 group-hover:${tutorial.color}/30 transition-colors`}>
                        <tutorial.icon className={`w-5 h-5 ${tutorial.color}`} />
                      </div>
                      <div>
                        <div className="flex items-center">
                          <h4 className="text-green-400 font-mono mb-1">{tutorial.title}</h4>
                          <span className={`ml-2 text-xs font-bold ${tutorial.color} px-2 py-0.5 rounded border border-current opacity-70`}>
                            {tutorial.type}
                          </span>
                        </div>
                        <p className="text-green-100/70 text-sm">{tutorial.description}</p>
                      </div>
                    </div>
                  </div>
                ))}
              </div>
              <div className="mt-6 text-center">
                <button className="bg-green-900/30 hover:bg-green-900/50 text-green-400 border border-green-500/30 px-4 py-2 rounded flex items-center space-x-2 mx-auto">
                  <Video size={16} />
                  <span>View All Tutorials</span>
                </button>
              </div>
            </section>

            {/* Unit Types Section */}
            <section className="bg-black/30 border border-green-500/20 p-6 rounded-lg">
              <h2 className="text-2xl font-mono text-green-400 mb-4 pb-2 border-b border-green-500/30">
                COMBAT UNITS
              </h2>
              <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                {unitTypes.map((unit, index) => (
                  <div key={index} className="p-4 bg-green-900/10 border border-green-500/20 rounded flex items-start space-x-3">
                    <unit.icon className="w-6 h-6 text-green-400 mt-1" />
                    <div>
                      <h4 className="text-green-400 font-mono mb-1">{unit.title}</h4>
                      <p className="text-green-100/70 text-sm">{unit.desc}</p>
                    </div>
                  </div>
                ))}
              </div>
            </section>

            {/* Tactics Grid */}
            <section className="bg-black/30 border border-green-500/20 p-6 rounded-lg">
              <h2 className="text-2xl font-mono text-green-400 mb-4 pb-2 border-b border-green-500/30">
                TACTICAL OPERATIONS
              </h2>
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                {tactics.map((tactic, index) => (
                  <div key={index} className="p-4 bg-green-900/10 border border-green-500/20 rounded">
                    <h4 className="text-green-400 font-mono mb-1">{tactic.name}</h4>
                    <p className="text-green-100/70 text-sm">{tactic.description}</p>
                  </div>
                ))}
              </div>
            </section>

            {/* Combat Operations */}
            <section className="bg-black/30 border border-green-500/20 p-6 rounded-lg">
              <h2 className="text-2xl font-mono text-green-400 mb-4 pb-2 border-b border-green-500/30">
                COMBAT OPERATIONS
              </h2>
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                {combatOps.map((op, index) => (
                  <div key={index} className="p-4 bg-green-900/10 border border-green-500/20 rounded">
                    <h4 className="text-green-400 font-mono mb-1">{op.name}</h4>
                    <p className="text-green-100/70 text-sm">{op.description}</p>
                  </div>
                ))}
              </div>
            </section>

            {/* Battlefield Section */}
            <section className="bg-black/30 border border-green-500/20 p-6 rounded-lg">
              <h2 className="text-2xl font-mono text-green-400 mb-4 pb-2 border-b border-green-500/30">
                BATTLEFIELD DYNAMICS
              </h2>
              <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                {battlefieldInfo.map((info, index) => (
                  <div key={index} className="space-y-3">
                    <h3 className="text-xl font-mono text-green-400">{info.terrain}</h3>
                    <ul className="space-y-2">
                      {info.features.map((feature, fIndex) => (
                        <li key={fIndex} className="text-green-100/70 flex items-center">
                          <span className="text-green-500 mr-2">›</span>
                          {feature}
                        </li>
                      ))}
                    </ul>
                  </div>
                ))}
              </div>
            </section>

            {/* Victory Conditions Section */}
            <section className="bg-black/30 border border-green-500/20 p-6 rounded-lg">
              <h2 className="text-2xl font-mono text-green-400 mb-4 pb-2 border-b border-green-500/30">
                VICTORY PROTOCOLS
              </h2>
              <div className="space-y-4">
                <div className="bg-green-900/10 border border-green-500/20 p-4 rounded">
                  <h4 className="text-green-400 font-mono mb-2">Primary Objective</h4>
                  <p className="text-green-100/70">Achieve 5 confirmed enemy unit eliminations to secure battlefield dominance</p>
                </div>
                <div className="bg-green-900/10 border border-green-500/20 p-4 rounded">
                  <h4 className="text-green-400 font-mono mb-2">Scoring Matrix</h4>
                  <ul className="space-y-2">
                    <li className="text-green-100/70">• Unit-specific elimination rewards</li>
                    <li className="text-green-100/70">• Tactical position control bonuses</li>
                    <li className="text-green-100/70">• Resource management efficiency</li>
                  </ul>
                </div>
              </div>
            </section>

            {/* Footer with Links */}
            <div className="mt-12 pt-4 border-t border-green-500/20 flex flex-wrap justify-between items-center">
              <div className="text-green-400/60 text-sm">
                <span className="font-mono">Terminal ID: XT-7291-A</span> • <span>Access Level: Commander</span>
              </div>
              <div className="flex space-x-4 text-green-400/60">
                <button onClick={() => window.location.href = '/dashboard'} className="hover:text-green-400 transition-colors">Dashboard</button>
                <button onClick={() => window.location.href = '/help'} className="hover:text-green-400 transition-colors">Command Center</button>
                <button onClick={() => window.location.href = '/faq'} className="hover:text-green-400 transition-colors">Armory</button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default About;